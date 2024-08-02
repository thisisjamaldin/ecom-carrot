import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:russsia_carrot/data/event_bus.dart';
import 'package:russsia_carrot/data/model/products_model.dart';
import 'package:russsia_carrot/features/bloc_favorites/favorites_bloc.dart';
import 'package:russsia_carrot/features/bloc_products/products_bloc.dart';
import '../../../features/cubit_save_token/save_token_cubit.dart';
import '../../../repository/abstract_repository.dart';
import '../../../router/router.dart';
import '../../bottom_navigate.dart';
import '../widget/list_recomend.dart';

@RoutePage()
class AllProductOwnerPage extends StatefulWidget {
  const AllProductOwnerPage({super.key, required this.products});

  final ResultProducts products;

  @override
  State<AllProductOwnerPage> createState() => _AllProductOwnerPageState();
}

class _AllProductOwnerPageState extends State<AllProductOwnerPage> {
  final _blocProducts = ProductsBloc(GetIt.I<AbstractRepository>());
  late String token;
  final eventBus = GetIt.I<EventBus>();

  @override
  void initState() {
    token = context.read<SaveTokenCubit>().state.token;
    _blocProducts.add(OwnerProductsEvent(
        token: token,
        limit: "100",
        owner: widget.products.owner.id.toString()));
    super.initState();
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
            "Мои объявления",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          bloc: _blocProducts,
          builder: (context, state) {
            if (state is ProductsLoaded) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
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
                          var listProduct = state.productsModel.results[index];
                          return GestureDetector(
                              onTap: () => context.pushRoute(
                                    DetailProductRoute(
                                        id: listProduct.id,
                                        idReviews: listProduct.owner.id),
                                  ),
                              child: ListRecommend(
                                products: listProduct,
                                clickFavorite: () {
                                  state.productsModel.results[index].favorite
                                      ? BlocProvider.of<FavoritesBloc>(context)
                                          .add(
                                          DeleteFavoriteEvent(
                                              id: state.productsModel
                                                  .results[index].id
                                                  .toString(),
                                              limit: '100',
                                              token: token),
                                        )
                                      : BlocProvider.of<FavoritesBloc>(context)
                                          .add(
                                          AddFavoriteEvent(
                                              productId: state.productsModel
                                                  .results[index].id
                                                  .toString(),
                                              limit: '100',
                                              token: token),
                                        );
                                  _blocProducts.add(OwnerProductsEvent(
                                      token: token,
                                      owner:
                                          widget.products.owner.id.toString(),
                                      limit: '100'));
                                  eventBus.fire(UpdateMainList());
                                },
                              ));
                        },
                        childCount: state.productsModel.results.length,
                      ),
                    ),
                  ),
                ],
              );
            }
            if (state is ProductsErrorState) {
              print(state.exception);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
        bottomNavigationBar: const BottomNavigate(index: 0),
      ),
    );
  }
}
