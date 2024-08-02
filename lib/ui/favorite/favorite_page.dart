import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:russsia_carrot/data/event_bus.dart';
import 'package:russsia_carrot/features/bloc_favorites/favorites_bloc.dart';
import 'package:russsia_carrot/router/router.dart';
import 'package:russsia_carrot/ui/favorite/widget/list_favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../features/cubit_save_token/save_token_cubit.dart';
import '../../theme/color_res.dart';

@RoutePage()
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  ///Products
  final limitFavorites = ValueNotifier(10);

  final ScrollController _scrollFavoritesController = ScrollController();
  final isLoadingProducts = ValueNotifier(false);
  String limit = '10';
  late String token;
  final eventBus = GetIt.I<EventBus>();

  @override
  void initState() {
    super.initState();
    token = context.read<SaveTokenCubit>().state.token;
    if (token.isEmpty) {
      Future.delayed(Duration.zero, () async {
        Navigator.of(context).pop();
        AutoRouter.of(context).replaceAll([MainRoute(), MainAuthRoute()]);
      });
    } else {
      BlocProvider.of<FavoritesBloc>(context).add(
        LoadFavoritesEvent(limit: limit, token: token),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Избранное',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FavoritesLoaded) {
            if (state.favoritesProducts.results.isEmpty) {
              Center(
                child: Text('Пусто'),
              );
            } else {
              return ListView.builder(
                itemCount: state.favoritesProducts.results.length,
                itemBuilder: (context, index) {
                  var listFavorite = state.favoritesProducts.results[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Slidable(
                        endActionPane: ActionPane(
                          dragDismissible: false,
                          closeThreshold: 0.1,
                          openThreshold: 0.23,
                          extentRatio: 0.25,
                          motion: const ScrollMotion(),
                          children: [
                            CustomSlidableAction(
                              onPressed: (context) {
                                BlocProvider.of<FavoritesBloc>(context)
                                    .add(DeleteFavoriteEvent(
                                  limit: limit,
                                  token: token,
                                  id: listFavorite.productData.id.toString(),
                                ));
                                eventBus.fire(UpdateMainList());
                              },
                              backgroundColor: ColorRes.red,
                              foregroundColor: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              child: const Icon(Icons.delete_outline_outlined),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () => AutoRouter.of(context).push(
                              DetailProductRoute(
                                  id: listFavorite.id,
                                  idReviews:
                                      listFavorite.productData.owner.id)),
                          child: ListFavorite(
                            favorites: listFavorite,
                          ),
                        )),
                  );
                },
              );
            }
          }
          if (state is FavoritesErrorState) {
            BlocProvider.of<FavoritesBloc>(context)
                .add(LoadFavoritesEvent(limit: limit, token: token));
            return Center(
              child: Text(state.exception.toString()),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
