import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../data/event_bus.dart';
import '../../../features/bloc_my_products/my_products_bloc.dart';
import '../../../features/cubit_save_token/save_token_cubit.dart';
import '../../../repository/abstract_repository.dart';
import '../../../router/router.dart';
import '../../../theme/color_res.dart';
import '../../bottom_navigate.dart';
import '../widget/list_recomend.dart';

@RoutePage()
class AllProductPage extends StatefulWidget {
  const AllProductPage({super.key});

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> {
  final _blocMyProducts = MyProductsBloc(GetIt.I<AbstractRepository>());
  late String token;
  final limit = ValueNotifier(10);
  final event = GetIt.I<EventBus>();

  @override
  void initState() {
    token = context.read<SaveTokenCubit>().state.token;
    _blocMyProducts.add(LoadMyProductsEvent(token: token, limit: limit.value));
    event.fire(UpdateCreate());
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
        body: BlocBuilder<MyProductsBloc, MyProductsState>(
          bloc: _blocMyProducts,
          builder: (context, state) {
            if (state is MyProductsLoaded) {
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
                        childAspectRatio: 0.68,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          var listProduct = state.resultProducts[index];
                          return GestureDetector(
                              onTap: () => context.pushRoute(
                                    DetailProductRoute(
                                        id: listProduct.id,
                                        idReviews: listProduct.owner.id),
                                  ),
                              child: ListRecommend2(
                                delete: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                      backgroundColor: ColorRes.greyText,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const SizedBox(height: 24),
                                            const Text(
                                                'Вы точно хотите удалить?'),
                                            const SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Назад',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _blocMyProducts.add(
                                                        DeleteMyProductEvent(
                                                      token: token,
                                                      limit: limit.value,
                                                      productId: listProduct.id,
                                                    ));
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Удалить',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                listProduct: listProduct,
                              ));
                        },
                        childCount: state.resultProducts.length,
                      ),
                    ),
                  ),
                ],
              );
            }
            if (state is MyProductsErrorState) {
              debugPrint(state.exception.toString());
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
        bottomNavigationBar: const BottomNavigate(index: 4),
      ),
    );
  }
}
