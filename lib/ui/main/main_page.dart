import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:russsia_carrot/data/event_bus.dart';
import 'package:russsia_carrot/features/bloc_category/category_product_bloc.dart';
import 'package:russsia_carrot/features/bloc_location/city_bloc.dart';
import 'package:russsia_carrot/features/bloc_products/products_bloc.dart';
import 'package:russsia_carrot/features/bloc_advertisements/advertisements_bloc.dart';
import 'package:russsia_carrot/generated/assets.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/router/router.dart';
import 'package:russsia_carrot/ui/main/widget/advertisement.dart';
import 'package:russsia_carrot/ui/main/widget/category_image.dart';
import 'package:russsia_carrot/ui/main/widget/list_category.dart';
import 'package:russsia_carrot/ui/main/widget/list_recomend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:get_it/get_it.dart';
import '../../data/model/categories_model.dart';
import '../../features/bloc_favorites/favorites_bloc.dart';
import '../../features/cubit_save_token/save_token_cubit.dart';
import '../../theme/color_res.dart';
import '../../utils/pagination_manager.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPage = 0;
  final checkText = ValueNotifier(false);
  final showCategory = ValueNotifier(false);

  ///Category
  final limitCategory = ValueNotifier(12);
  final _blocCategory = CategoryProductBloc(GetIt.I<AbstractRepository>());
  final ScrollController _scrollCategoryController = ScrollController();
  final isLoading = ValueNotifier(false);

  ///Products
  final _blocProducts = ProductsBloc(GetIt.I<AbstractRepository>());
  final limitProducts = ValueNotifier(6);
  final ScrollController _scrollProductsController = ScrollController();
  final isLoadingProducts = ValueNotifier(false);

  ///Баннер с рекламой
  final _blocAdvert = AdvertisementsBloc(GetIt.I<AbstractRepository>());
  final limitAdvert = ValueNotifier(2);
  final isLoadingAdvert = ValueNotifier(false);
  late final PageController _pageController;

  late String token;
  bool showPaginationProducts = true;
  String searchText = '';
  final eventBus = GetIt.I<EventBus>();
  final _blocCity = CityBloc(GetIt.I<AbstractRepository>());
  String _city = 'Загрузка...';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedPage);
    _pageController.addListener(() {
      setState(() {
        selectedPage = _pageController.page?.round() ?? 0;
      });
    });
    _getCurrentLocation();
    token = context.read<SaveTokenCubit>().state.token;
    debugPrint(token);
    pagination();
    paginationCategoryFun(showPaginationProducts, 10);
    eventBus.on<UpdateMainList>().listen((event) {
      token = context.read<SaveTokenCubit>().state.token;
      pagination();
      if (searchText.isNotEmpty) {
        loadFindProductsData();
      } else {
        loadProductsData();
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _city = 'Геолокация отключена';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _city = 'Разрешение на геолокацию отклонено';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _city = 'Разрешение на геолокацию отклонено навсегда';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _blocCity.add(FetchCity(position));
  }

  void loadAdvert() {
    _blocAdvert.add(LoadAdvertisementsEvent(limit: limitAdvert.value));
  }

  void loadCategoryData() {
    _blocCategory.add(LoadCategoryProductEvent(limit: limitCategory.value));
  }

  void loadProductsData() {
    _blocProducts
        .add(LoadProductsEvent(limit: limitProducts.value, token: token));
  }

  void loadFindProductsData() {
    _blocProducts.add(FindProductEvent(searchText: searchText, token: token));
    isLoadingProducts.value = false;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollCategoryController.dispose();
    _scrollProductsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<CategoryProductBloc, CategoryProductState>(
          bloc: _blocCategory,
          builder: (context, stateCategory) {
            if (stateCategory is CategoryProductLoaded) {
              return ValueListenableBuilder(
                valueListenable: showCategory,
                builder: (context, value, child) => showCategory.value
                    ? ValueListenableBuilder(
                        valueListenable: limitCategory,
                        builder: (context, value, child) => CustomScrollView(
                          controller: _scrollCategoryController,
                          slivers: [
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.only(left: 22.0, top: 24),
                                child: Text(
                                  'Категории',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30),
                                ),
                              ),
                            ),
                            ListCategory(
                              category: stateCategory.categoryModel,
                              clickItem: (String id) {
                                showCategory.value = false;
                                _blocProducts.add(SelectCategoryEvent(
                                    category: id,
                                    limit: limitProducts.value,
                                    token: token));
                                setState(() {});
                              },
                            ),
                            // SliverToBoxAdapter(
                            //   child: ValueListenableBuilder(
                            //     valueListenable: isLoading,
                            //     builder: (context, value, child) => Visibility(
                            //       visible: !isLoading.value,
                            //       child: const Center(
                            //         child: CircularProgressIndicator(),
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      )
                    : ValueListenableBuilder(
                        valueListenable: limitProducts,
                        builder: (context, value, child) {
                          return CustomScrollView(
                            controller: _scrollProductsController,
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    ///Location
                                    const SizedBox(height: 16),
                                    BlocBuilder<CityBloc, CityState>(
                                      bloc: _blocCity,
                                      builder: (context, state) {
                                        return Row(
                                          children: [
                                            // const SizedBox(width: 24),
                                            // Container(
                                            //   padding:
                                            //       const EdgeInsets.symmetric(
                                            //           vertical: 10,
                                            //           horizontal: 12),
                                            //   decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.circular(200),
                                            //     color: ColorRes.orange,
                                            //   ),
                                            //   child: SvgPicture.asset(
                                            //       Assets.iconsLocation),
                                            // ),
                                            // const SizedBox(width: 20),
                                            // const Text(
                                            //   'Ваш город: ',
                                            //   style: TextStyle(fontSize: 12),
                                            // ),
                                            if (state is CityLoaded)
                                              Text(
                                                state.city,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        Colors.white),
                                              ),
                                            if (state is CityError)
                                              Text(
                                                state.errorMessage,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        Colors.white),
                                              ),
                                            if (state is CityLoading)
                                              Text(
                                                _city,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        Colors.white),
                                              ),
                                            const Spacer(),
                                            GestureDetector(
                                                onTap: () {
                                                  if (context
                                                      .read<SaveTokenCubit>()
                                                      .state
                                                      .token
                                                      .isEmpty) {
                                                    Future.delayed(
                                                        Duration.zero,
                                                        () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      AutoRouter.of(context)
                                                          .replaceAll([
                                                        MainRoute(),
                                                        MainAuthRoute()
                                                      ]);
                                                    });
                                                  } else {
                                                    AutoRouter.of(context).push(
                                                      NotificationRoute(
                                                          isProfile: false),
                                                    );
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                    Assets.iconsNotifications)),
                                            const SizedBox(width: 30),
                                          ],
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    ///SearchText
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: ColorRes.grey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 16),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            child: SvgPicture.asset(
                                                Assets.iconsSearch),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                              child: SizedBox(
                                                  height: 14,
                                                  child: ValueListenableBuilder(
                                                    valueListenable: checkText,
                                                    builder: (context, value,
                                                            child) =>
                                                        Stack(
                                                      children: [
                                                        Text(
                                                          !value
                                                              ? 'Введите название товара'
                                                              : '',
                                                          style: const TextStyle(
                                                              fontSize: 10,
                                                              color: ColorRes
                                                                  .greyWhite),
                                                        ),
                                                        TextField(
                                                          onChanged: (value) {
                                                            searchText = value;
                                                            if (value.isEmpty) {
                                                              checkText.value =
                                                                  false;
                                                              showPaginationProducts =
                                                                  true;
                                                              paginationCategoryFun(
                                                                  true,
                                                                  limitProducts
                                                                      .value);
                                                            } else {
                                                              checkText.value =
                                                                  true;
                                                              _blocProducts.add(
                                                                  FindProductEvent(
                                                                      token:
                                                                          token,
                                                                      searchText:
                                                                          value));
                                                              showPaginationProducts =
                                                                  false;
                                                              isLoading.value =
                                                                  false;
                                                            }
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .transparent),
                                                            ),
                                                            border: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    ///Advertisement
                                    BlocBuilder<AdvertisementsBloc,
                                        AdvertisementsState>(
                                      bloc: _blocAdvert,
                                      builder: (context, stateAdvert) {
                                        if (stateAdvert
                                            is LoadedAdvertisementsState) {
                                          return ValueListenableBuilder(
                                              valueListenable: limitAdvert,
                                              builder: (context, value, child) {
                                                return Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 112,
                                                      child: PageView.builder(
                                                        controller:
                                                            _pageController,
                                                        onPageChanged:
                                                            (int page) {
                                                          setState(() {
                                                            selectedPage = page;
                                                          });
                                                        },
                                                        itemCount: stateAdvert
                                                            .advertisementsModel
                                                            .results
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final listAdvert =
                                                              stateAdvert
                                                                  .advertisementsModel
                                                                  .results[index];
                                                          return Advertisement(
                                                            image: listAdvert
                                                                .photo,
                                                            title: listAdvert
                                                                .title,
                                                            desc: listAdvert
                                                                .description,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 22.0),
                                                      child: DotsIndicator(
                                                        dotsCount: stateAdvert
                                                            .advertisementsModel
                                                            .results
                                                            .length,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        position: selectedPage,
                                                        decorator:
                                                            DotsDecorator(
                                                          color: ColorRes.grey,
                                                          activeColor:
                                                              ColorRes.orange,
                                                          activeSize:
                                                              const Size.square(
                                                                  9.0),
                                                          size: const Size(
                                                              18.0, 9.0),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        }
                                        if (stateAdvert
                                            is ErrorAdvertisementsState) {
                                          return Center(
                                            child: Text(
                                              stateAdvert.exception.toString(),
                                            ),
                                          );
                                        }
                                        return const SizedBox(height: 120);
                                      },
                                    ),

                                    const SizedBox(height: 12),

                                    ///Category
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Категории',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18),
                                          ),
                                          GestureDetector(
                                            onTap: () => showCategory.value =
                                                !showCategory.value,
                                            child: const Text(
                                              'Посмотреть все',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: ColorRes.orange,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      ColorRes.orange),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: loadCategory(
                                        stateCategory.categoryModel.results,
                                        (id) {
                                          _blocProducts.add(SelectCategoryEvent(
                                              category: id,
                                              limit: limitProducts.value,
                                              token: token));
                                          showPaginationProducts = false;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: loadCategory(
                                        stateCategory.categoryModel.results,
                                        (id) {
                                          _blocProducts.add(SelectCategoryEvent(
                                              category: id,
                                              limit: limitProducts.value,
                                              token: token));
                                          showPaginationProducts = false;
                                        },
                                        secondList: true,
                                      ),
                                    ),

                                    ///Recommend
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(
                                          left: 22, top: 20),
                                      child: const Text(
                                        'Рекомендации',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                              BlocBuilder<ProductsBloc, ProductsState>(
                                bloc: _blocProducts,
                                builder: (context, state) {
                                  if (state is ProductsLoaded) {
                                    return SliverPadding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22),
                                      sliver: SliverGrid(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 12,
                                          childAspectRatio: 0.7,
                                        ),
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  if (context
                                                      .read<SaveTokenCubit>()
                                                      .state
                                                      .token
                                                      .isEmpty) {
                                                    Future.delayed(
                                                        Duration.zero,
                                                        () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      AutoRouter.of(context)
                                                          .replaceAll([
                                                        MainRoute(),
                                                        MainAuthRoute()
                                                      ]);
                                                    });
                                                  } else {
                                                    context.pushRoute(
                                                      DetailProductRoute(
                                                          id: state
                                                              .productsModel
                                                              .results[index]
                                                              .id,
                                                          idReviews: state
                                                              .productsModel
                                                              .results[index]
                                                              .owner
                                                              .id),
                                                    );
                                                  }
                                                },
                                                child: ListRecommend(
                                                  clickFavorite: () {
                                                    if (context
                                                        .read<SaveTokenCubit>()
                                                        .state
                                                        .token
                                                        .isEmpty) {
                                                      Future.delayed(
                                                          Duration.zero,
                                                          () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        AutoRouter.of(context)
                                                            .replaceAll([
                                                          MainRoute(),
                                                          MainAuthRoute()
                                                        ]);
                                                      });
                                                    } else {
                                                      state
                                                              .productsModel
                                                              .results[index]
                                                              .favorite
                                                          ? BlocProvider.of<
                                                                      FavoritesBloc>(
                                                                  context)
                                                              .add(
                                                              DeleteFavoriteEvent(
                                                                  id: state
                                                                      .productsModel
                                                                      .results[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  limit: '15',
                                                                  token: token),
                                                            )
                                                          : BlocProvider.of<
                                                                      FavoritesBloc>(
                                                                  context)
                                                              .add(
                                                              AddFavoriteEvent(
                                                                  productId: state
                                                                      .productsModel
                                                                      .results[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  limit: '15',
                                                                  token: token),
                                                            );
                                                      paginationCategoryFun(
                                                          true,
                                                          limitProducts.value);
                                                    }
                                                  },
                                                  products: state.productsModel
                                                      .results[index],
                                                ));
                                          },
                                          childCount: state
                                              .productsModel.results.length,
                                        ),
                                      ),
                                    );
                                  }
                                  if (state is ProductsFind) {
                                    return SliverPadding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22),
                                      sliver: SliverGrid(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 12,
                                          childAspectRatio: 0.7,
                                        ),
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  if (context
                                                      .read<SaveTokenCubit>()
                                                      .state
                                                      .token
                                                      .isEmpty) {
                                                    Future.delayed(
                                                        Duration.zero,
                                                        () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      AutoRouter.of(context)
                                                          .replaceAll([
                                                        MainRoute(),
                                                        MainAuthRoute()
                                                      ]);
                                                    });
                                                  } else {
                                                    context.pushRoute(
                                                      DetailProductRoute(
                                                          id: state
                                                              .productsModel
                                                              .results[index]
                                                              .id,
                                                          idReviews: state
                                                              .productsModel
                                                              .results[index]
                                                              .owner
                                                              .id),
                                                    );
                                                  }
                                                },
                                                child: ListRecommend(
                                                  clickFavorite: () {
                                                    if (context
                                                        .read<SaveTokenCubit>()
                                                        .state
                                                        .token
                                                        .isEmpty) {
                                                      Future.delayed(
                                                          Duration.zero,
                                                          () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        AutoRouter.of(context)
                                                            .replaceAll([
                                                          MainRoute(),
                                                          MainAuthRoute()
                                                        ]);
                                                      });
                                                    } else {
                                                      state
                                                              .productsModel
                                                              .results[index]
                                                              .favorite
                                                          ? BlocProvider.of<
                                                                      FavoritesBloc>(
                                                                  context)
                                                              .add(
                                                              DeleteFavoriteEvent(
                                                                  id: state
                                                                      .productsModel
                                                                      .results[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  limit: '15',
                                                                  token: token),
                                                            )
                                                          : BlocProvider.of<
                                                                      FavoritesBloc>(
                                                                  context)
                                                              .add(
                                                              AddFavoriteEvent(
                                                                  productId: state
                                                                      .productsModel
                                                                      .results[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  limit: '15',
                                                                  token: token),
                                                            );
                                                      _blocProducts.add(
                                                          FindProductEvent(
                                                              token: token,
                                                              searchText:
                                                                  searchText));
                                                    }
                                                  },
                                                  products: state.productsModel
                                                      .results[index],
                                                ));
                                          },
                                          childCount: state
                                              .productsModel.results.length,
                                        ),
                                      ),
                                    );
                                  }
                                  if (state is ProductsErrorState) {
                                    return const SliverToBoxAdapter(
                                        child: SizedBox());
                                  }
                                  return const SliverToBoxAdapter(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                              SliverToBoxAdapter(
                                child: ValueListenableBuilder(
                                  valueListenable: isLoadingProducts,
                                  builder: (context, value, child) =>
                                      const Visibility(
                                    visible: false,

                                    ///!isLoadingProducts.value,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
              );
            }
            if (stateCategory is CategoryProductErrorState) {
              return Center(
                child: Text("${stateCategory.exception}"),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Row loadCategory(List<Result> result, Function(String id) click,
      {bool secondList = false}) {
    List<Result> displayedResults;

    if (secondList) {
      displayedResults = result.skip(4).take(4).toList();
    } else {
      displayedResults = result.take(4).toList();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: displayedResults.length <= 4
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.spaceBetween,
      children: displayedResults
          .map((result) => GestureDetector(
                onTap: () => click(result.id.toString()),
                child: CategoryImage(
                  title: result.name,
                  image: result.photo,
                ),
              ))
          .toList(),
    );
  }

  void pagination() {
    _initializePaginationManager(
      isLoading: isLoading,
      limit: limitCategory,
      load: loadCategoryData,
      scrollController: _scrollCategoryController,
      shouldPaginate: true,
    );

    // _initializePaginationManager(
    //   isLoading: isLoadingProducts,
    //   limit: limitProducts,
    //   load: loadProductsData,
    //   scrollController: _scrollProductsController,
    //   shouldPaginate: true,
    // );

    _initializePaginationManager(
      isLoading: isLoadingAdvert,
      limit: limitAdvert,
      load: loadAdvert,
      scrollController: _pageController,
      shouldPaginate: true,
    );
  }

  void paginationCategoryFun(bool paginate, int limitList) {
    showPaginationProducts = paginate;
    if (showPaginationProducts == false) {
      isLoadingProducts.value = false;
      limitCategory.value = limitList;
      loadProductsData();
    } else {
      loadProductsData();
      _scrollProductsController.addListener(_scrollCategoryListener);
    }
  }

  void _scrollCategoryListener() {
    if (_scrollProductsController.offset >=
            _scrollProductsController.position.maxScrollExtent &&
        !_scrollProductsController.position.outOfRange) {
      // Достигнут конец списка, обработка пагинации здесь
      // Вызовите метод загрузки новых данных
      if (showPaginationProducts) {
        _loadCategoryMoreData();
      }
    }
  }

  void _loadCategoryMoreData() {
    isLoadingProducts.value = true;
    limitProducts.value += 30;
    loadProductsData();
  }

  void _initializePaginationManager({
    required ValueNotifier<bool> isLoading,
    required ValueNotifier<int> limit,
    required VoidCallback load,
    required ScrollController scrollController,
    required bool shouldPaginate,
  }) {
    PaginationManager paginationManager = PaginationManager(
      isLoading: isLoading,
      limitCategory: limit,
      load: load,
      scrollCategoryController: scrollController,
      shouldPaginate: shouldPaginate,
    );

    paginationManager.paginationCategoryFun(shouldPaginate, limit.value);
  }
}
