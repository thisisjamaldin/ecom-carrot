import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:russsia_carrot/data/event_bus.dart';
import 'package:russsia_carrot/data/model/products_model.dart';
import 'package:russsia_carrot/features/bloc_favorites/favorites_bloc.dart';
import 'package:russsia_carrot/features/bloc_products/products_bloc.dart';
import 'package:russsia_carrot/features/bloc_reviews/reviews_bloc.dart';
import 'package:russsia_carrot/features/cubit_save_token/save_token_cubit.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/router/router.dart';
import 'package:russsia_carrot/ui/profile/widget/list_reviews.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/assets.dart';
import '../../theme/color_res.dart';
import '../bottom_navigate.dart';
import '../main/widget/list_recomend.dart';

@RoutePage()
class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({super.key, required this.products});

  final ResultProducts products;

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  final _blocReviews = ReviewsBloc(GetIt.I<AbstractRepository>());
  final _blocProducts = ProductsBloc(GetIt.I<AbstractRepository>());
  late String token;
  final eventBus = GetIt.I<EventBus>();

  void loadData() {
    _blocReviews.add(LoadReviewsEvent(
        token: token, user: widget.products.owner.id.toString()));
    _blocProducts.add(OwnerProductsEvent(
        token: token,
        limit: "100",
        owner: widget.products.owner.id.toString()));
  }

  @override
  void initState() {
    super.initState();
    token = context.read<SaveTokenCubit>().state.token;
    eventBus.on<UpdateIvan>().listen((event) {
      loadData();
    });
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              CupertinoIcons.left_chevron,
              color: Colors.white,
            ),
          ),
          title: const Text(
            "Профиль продавца",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: widget.products.owner.image.isEmpty
                                    ? Image.asset(Assets.imagesPerson)
                                    : Image.network(
                                        widget.products.owner.image,
                                        width: 60,
                                        height: 60,
                                      )),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        "${widget.products.owner.firstName} ${widget.products.owner.lastName}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SvgPicture.asset(Assets.iconsStar),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      widget.products.owner.raiting
                                          .toDouble()
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  widget.products.owner.email.isNotEmpty
                                      ? widget.products.owner.email
                                      : widget.products.owner.phone,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: ColorRes.greyNumber),
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Сделок завершено ",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.products.owner
                                            .completedTransactions
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: ColorRes.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  print('----tel:${widget.products.owner.phone}');
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: widget.products.owner.phone,
                                  );
                                  if (await canLaunchUrl(launchUri)) {
                                    await launchUrl(launchUri);
                                  } else {
                                    throw 'Could not launch $launchUri';
                                  }
                                  //TODO:Реализовать звонок
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                      color: ColorRes.grey,
                                      borderRadius: BorderRadius.circular(200)),
                                  child: SvgPicture.asset(Assets.iconsPhone),
                                )),
                            // const SizedBox(
                            //   width: 7,
                            // ),
                            // GestureDetector(
                            //     onTap: () {
                            //       //TODO:Реализовать переход на экран переписки
                            //     },
                            //     child: SvgPicture.asset(Assets.iconsSms)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 29,
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<ProductsBloc, ProductsState>(
              bloc: _blocProducts,
              builder: (context, state) {
                if (state is ProductsLoaded) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "Объявления ${widget.products.owner.firstName} ",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "(${state.productsModel.results.length})",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF48474A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  AutoRouter.of(context).push(
                                      AllProductOwnerRoute(
                                          products: widget.products));
                                },
                                child: const Text(
                                  "смотреть все",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: ColorRes.orange,
                                      decoration: TextDecoration.underline,
                                      decorationColor: ColorRes.orange),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.productsModel.results.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () => context.pushRoute(
                                          DetailProductRoute(
                                              id: state.productsModel
                                                  .results[index].id,
                                              idReviews: state.productsModel
                                                  .results[index].owner.id),
                                        ),
                                    child: Container(
                                        width: 170,
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: ListRecommend(
                                          products: state
                                              .productsModel.results[index],
                                          clickFavorite: () {
                                            state.productsModel.results[index]
                                                    .favorite
                                                ? BlocProvider.of<
                                                        FavoritesBloc>(context)
                                                    .add(
                                                    DeleteFavoriteEvent(
                                                        id: state.productsModel
                                                            .results[index].id
                                                            .toString(),
                                                        limit: '100',
                                                        token: token),
                                                  )
                                                : BlocProvider.of<
                                                        FavoritesBloc>(context)
                                                    .add(
                                                    AddFavoriteEvent(
                                                        productId: state
                                                            .productsModel
                                                            .results[index]
                                                            .id
                                                            .toString(),
                                                        limit: '100',
                                                        token: token),
                                                  );
                                            _blocProducts.add(
                                                OwnerProductsEvent(
                                                    token: token,
                                                    owner: widget
                                                        .products.owner.id
                                                        .toString(),
                                                    limit: '100'));
                                            eventBus.fire(UpdateMainList());
                                          },
                                        )));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is ProductsErrorState) {
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text(state.exception.toString()),
                    ),
                  );
                }
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
            BlocBuilder<ReviewsBloc, ReviewsState>(
              bloc: _blocReviews,
              builder: (context, state) {
                if (state is LoadedReviewsState) {
                  return SliverToBoxAdapter(
                    child: Visibility(
                      visible: state.reviewsModel.results.isNotEmpty,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 22,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Отзывы ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "(${state.reviewsModel.results.length})",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF48474A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AutoRouter.of(context).push(AllReviewsRoute(
                                        id: widget.products.owner.id
                                            .toString()));
                                  },
                                  child: const Text(
                                    "смотреть все",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: ColorRes.orange,
                                        decoration: TextDecoration.underline,
                                        decorationColor: ColorRes.orange),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 90,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.reviewsModel.results.length,
                              itemBuilder: (context, index) {
                                return ListReviews(
                                  reviews: state.reviewsModel.results[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is ErrorReviewsState) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text("${state.exception}"),
                    ),
                  );
                }
                return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
              },
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      AutoRouter.of(context)
                          .push(WriteReviewsRoute(products: widget.products));
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 20),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          color: ColorRes.orange,
                          borderRadius: BorderRadius.circular(6)),
                      child: const Text('Оставить отзыв'),
                    ),
                  ),
                  // const SizedBox(height: 20),
                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(6),
                  //       color: ColorRes.grey),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       const Text(
                  //         'Пожаловаться',
                  //         style: TextStyle(fontSize: 10, color: ColorRes.red),
                  //       ),
                  //       const SizedBox(width: 4),
                  //       SvgPicture.asset(Assets.iconsWarning)
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 46)
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavigate(index: 0),
      ),
    );
  }
}
