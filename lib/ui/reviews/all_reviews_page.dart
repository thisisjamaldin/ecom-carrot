import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:russsia_carrot/features/bloc_reviews/reviews_bloc.dart';
import 'package:russsia_carrot/features/cubit_save_token/save_token_cubit.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/ui/reviews/widgets/list_all_reviews.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../bottom_navigate.dart';

@RoutePage()
class AllReviewsPage extends StatefulWidget {
  const AllReviewsPage({super.key, required this.id});

  final String id;
  @override
  State<AllReviewsPage> createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage> {
  final _blocReviews = ReviewsBloc(GetIt.I<AbstractRepository>());
  late String token;

  void loadData() {
    _blocReviews.add(LoadReviewsEvent(token: token, user: widget.id));
  }

  @override
  void initState() {
    super.initState();
    token = context.read<SaveTokenCubit>().state.token;
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
          "Все отзывы",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      body: BlocBuilder<ReviewsBloc, ReviewsState>(
        bloc: _blocReviews,
        builder: (context, state) {
          if (state is LoadedReviewsState) {
            return SizedBox(
              height: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: state.reviewsModel.results.length,
                itemBuilder: (context, index) {
                  return ListAllReviews(
                    reviews: state.reviewsModel.results[index],
                  );
                },
              ),
            );
          }
          if (state is ErrorReviewsState) {
            return Center(
              child: Text("${state.exception}"),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: const BottomNavigate(index: 0),
    ));
  }
}
