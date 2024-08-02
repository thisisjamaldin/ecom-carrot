import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:russsia_carrot/data/local/pref.dart';
import 'package:russsia_carrot/features/bloc_chat/chat_bloc.dart';
import 'package:russsia_carrot/features/bloc_product_detail/product_detail_bloc.dart';
import 'package:russsia_carrot/features/bloc_reviews/reviews_bloc.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/event_bus.dart';
import '../../../features/bloc_favorites/favorites_bloc.dart';
import '../../../features/cubit_save_token/save_token_cubit.dart';
import '../../../generated/assets.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../theme/color_res.dart';

@RoutePage()
class DetailProductPage extends StatefulWidget {
  const DetailProductPage(
      {super.key, required this.id, required this.idReviews});

  final int id;
  final int idReviews;

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  int selectedPage = 0;
  late final PageController _pageController;
  final checkText = ValueNotifier(false);
  final _blocProductDetail = ProductDetailBloc(GetIt.I<AbstractRepository>());
  final _blocReviews = ReviewsBloc(GetIt.I<AbstractRepository>());
  late String token;
  final eventBus = GetIt.I<EventBus>();

  @override
  void initState() {
    super.initState();
    token = context.read<SaveTokenCubit>().state.token;
    initData();
    _pageController = PageController(initialPage: selectedPage);
    _pageController.addListener(() {
      setState(() {
        selectedPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  void initData() {
    _blocProductDetail.add(LoadProductDetailEvent(id: widget.id, token: token));
    _blocReviews
        .add(LoadReviewsEvent(token: token, user: widget.idReviews.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          bloc: _blocProductDetail,
          builder: (context, state) {
            if (state is ProductDetailLoaded) {
              // var lengthImage = state.resultProducts.photos.isEmpty
              //     ? 1
              //     : state.resultProducts.photos.length;
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 280,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: _pageController,
                                itemCount: state.resultProducts.photos.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        AutoRouter.of(context).push(
                                            PhotoDetailRoute(
                                                photos:
                                                    state.resultProducts.photos));
                                      },
                                      child: state.resultProducts.photos[index]
                                              .photo.isEmpty
                                          ? Image.asset(
                                              Assets.imagesHeadphones,
                                              fit: BoxFit.fill,
                                              width: double.infinity,
                                            )
                                          : Image.network(
                                              state.resultProducts.photos[index]
                                                  .photo,
                                              fit: BoxFit.fill,
                                              width: double.infinity,
                                            ));
                                },
                              ),
                              Positioned(
                                top: MediaQuery.of(context).padding.top,
                                left: 10,
                                right: 10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: ColorRes.greyWhite.withOpacity(0.5)),
                                        padding: const EdgeInsets.all(8),
                                        child: SvgPicture.asset(
                                            Assets.iconsChevronLeft),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            state.resultProducts.favorite
                                                ? BlocProvider.of<FavoritesBloc>(
                                                        context)
                                                    .add(
                                                    DeleteFavoriteEvent(
                                                        id: state
                                                            .resultProducts.id
                                                            .toString(),
                                                        limit: '15',
                                                        token: token),
                                                  )
                                                : BlocProvider.of<FavoritesBloc>(
                                                        context)
                                                    .add(
                                                    AddFavoriteEvent(
                                                        productId: state
                                                            .resultProducts.id
                                                            .toString(),
                                                        limit: '15',
                                                        token: token),
                                                  );
        
                                            initData();
                                            eventBus.fire(UpdateMainList());
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: ColorRes.grey,
                                              borderRadius:
                                                  BorderRadius.circular(200),
                                            ),
                                            child: Icon(
                                              state.resultProducts.favorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        GestureDetector(
                                          onTap: () {
                                            final shareUrl =
                                                'carrot://195.49.215.94/api/v1/detail-product/${widget.id}/${widget.idReviews}';
                                            Share.share(shareUrl);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: ColorRes.grey,
                                              borderRadius:
                                                  BorderRadius.circular(200),
                                            ),
                                            child: SvgPicture.asset(
                                                Assets.iconsShare),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: DotsIndicator(
                            dotsCount: state.resultProducts.photos.length,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            position: selectedPage,
                            decorator: DotsDecorator(
                              color: ColorRes.grey,
                              activeColor: ColorRes.orange,
                              // activeSize: const Size.square(9.0),
                              // size: const Size(18.0, 9.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        ///List Image
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 22.0),
                            child: Text(
                              state.resultProducts.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
        
                        ///Name product
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const SizedBox(width: 22),
                            Text(
                              "${double.parse(state.resultProducts.price).toInt()} ₩",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Договорная',
                              style:
                                  TextStyle(color: ColorRes.orange, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
        
                        ///Description
                        const SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(left: 22.0),
                            child: Text(
                              'Описание',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 22),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: ColorRes.grey,
                              borderRadius: BorderRadius.circular(6)),
                          child: AutoSizeText(state.resultProducts.description),
                        ),
                        const SizedBox(height: 20),
        
                        ///Seller
                        const SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(left: 22.0),
                            child: Text(
                              'Продавец',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            AutoRouter.of(context).push(SellerProfileRoute(
                                products: state.resultProducts));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 22),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                                color: ColorRes.grey,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: state
                                              .resultProducts.owner.image.isEmpty
                                          ? Image.asset(Assets.imagesPerson)
                                          : Image.network(
                                              state.resultProducts.owner.image,
                                              width: 60,
                                              height: 60,
                                            ),
                                    ),
                                    const SizedBox(width: 14),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${state.resultProducts.owner.firstName} ${state.resultProducts.owner.lastName}"),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            SvgPicture.asset(Assets.iconsStar),
                                            const SizedBox(width: 4),
                                            const Text(
                                              'Отзывы',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff868686)),
                                            ),
                                            const SizedBox(width: 4),
                                            BlocBuilder<ReviewsBloc,
                                                ReviewsState>(
                                              bloc: _blocReviews,
                                              builder: (context, state) {
                                                if (state is LoadedReviewsState) {
                                                  return Text(
                                                    '(${state.reviewsModel.results.length})',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  );
                                                }
                                                if (state is ErrorReviewsState) {
                                                  return Text(
                                                      "${state.exception}");
                                                }
                                                return const Text(
                                                  '(0)',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SvgPicture.asset(Assets.iconsChevronRight)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<ChatBloc>().add(ChatCreateEvent(
                                name: state.resultProducts.name,
                                token: token,
                                user: state.resultProducts.owner.id,
                                productId: state.resultProducts.id,
                                uuid: state.resultProducts.owner.chatUiid));
                            context.pushRoute(MessageDetailRoute());
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
                            child: const Text('Связаться с продавцом'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (c) {
                                  TextEditingController ctrl =
                                      TextEditingController();
                                  return Center(
                                    child: Container(
                                      margin: EdgeInsets.all(20),
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: ColorRes.grey,
                                          borderRadius: BorderRadius.circular(8)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Пожаловаться на ${state.resultProducts.name}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text('Опишите вашу жалобу'),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    12, 0, 12, 0),
                                                decoration: BoxDecoration(
                                                    color: ColorRes.greyDark,
                                                    borderRadius:
                                                        BorderRadius.circular(8)),
                                                child: TextField(
                                                  controller: ctrl,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: null,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none),
                                                ),
                                              )),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (ctrl.text.isEmpty) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Опишите жалобу')),
                                                    );
                                                    return;
                                                  }
                                                  Navigator.pop(c);
                                                  GetIt.I<AbstractRepository>()
                                                      .sendReport(
                                                          token,
                                                          'productid=${state.resultProducts.id}',
                                                          Pref().getName().isEmpty
                                                              ? 'Null'
                                                              : Pref().getName(),
                                                          Pref()
                                                                  .getEmail()
                                                                  .isEmpty
                                                              ? 'null@mail.com'
                                                              : Pref().getEmail(),
                                                          Pref()
                                                                  .getNumber()
                                                                  .isEmpty
                                                              ? '+78123456789'
                                                              : Pref()
                                                                  .getNumber(),
                                                          ctrl.text);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Жалоба отправлена')),
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          22, 4, 22, 4),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: ColorRes.orange),
                                                  child: const Text('Отправить'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(c);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          22, 4, 22, 4),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: ColorRes.greyDark),
                                                  child: const Text('Отменить'),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: ColorRes.grey),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Пожаловаться',
                                  style: TextStyle(
                                      fontSize: 10, color: ColorRes.red),
                                ),
                                const SizedBox(width: 4),
                                SvgPicture.asset(Assets.iconsWarning)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 46)
                      ],
                    ),
                  )
                ],
              );
            }
            if (state is ProductDetailErrorState) {
              return Center(
                child: Text("${state.exception}"),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
