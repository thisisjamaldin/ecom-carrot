import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:russsia_carrot/data/model/products_model.dart';
import 'package:russsia_carrot/features/bloc_add_reviews/add_reviews_bloc.dart';
import 'package:russsia_carrot/features/cubit_save_token/save_token_cubit.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

import '../../data/event_bus.dart';
import '../../generated/assets.dart';
import '../../theme/color_res.dart';
import '../bottom_navigate.dart';

@RoutePage()
class WriteReviewsPage extends StatefulWidget {
  const WriteReviewsPage({super.key, required this.products});

  final ResultProducts products;

  @override
  State<WriteReviewsPage> createState() => _WriteReviewsPageState();
}

class _WriteReviewsPageState extends State<WriteReviewsPage> {
  final ValueNotifier<int> _ratingNotifier = ValueNotifier<int>(1);
  int rating = 0;
  final TextEditingController _controller = TextEditingController();
  final _blocReviews = AddReviewsBloc(GetIt.I<AbstractRepository>());
  late String token;
  final eventBus  = GetIt.I<EventBus>();

  @override
  void initState() {
    super.initState();
    token = context.read<SaveTokenCubit>().state.token;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Оставить отзыв",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: widget.products.owner.image.isEmpty
                      ? Image.asset(
                          Assets.imagesPerson,
                          width: 100,
                          height: 100,
                        )
                      : Image.network(
                          widget.products.owner.image,
                          width: 100,
                          height: 100,
                        )),
              const SizedBox(
                height: 20,
              ),
              Text(widget.products.owner.firstName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(
                height: 22,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ValueListenableBuilder<int>(
                  valueListenable: _ratingNotifier,
                  builder: (context, rating, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => IconButton(
                          icon: Icon(
                            index < rating
                                ? CupertinoIcons.star_fill
                                : CupertinoIcons.star,
                            color: ColorRes.yellow,
                            size: 32,
                          ),
                          onPressed: () {
                            _ratingNotifier.value = index + 1;
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 42,
              ),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Подробности',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ColorRes.grey,
                ),
                padding: const EdgeInsets.only(bottom: 12),
                constraints: const BoxConstraints(
                  maxHeight: 200.0,
                ),
                child: Stack(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText:
                            "Подробно опишите все плюсы/минусы сделки\nс продавцом",
                        hintStyle: TextStyle(
                          color: ColorRes.greyHint,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        counterText: "",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 17, vertical: 20),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      onChanged: (t) {
                        setState(() {});
                      },
                      maxLength: 9000,
                      maxLines: null,
                      minLines: 10,
                    ),
                    Positioned(
                      right: 20,
                      bottom: 0,
                      child: Text(
                        '${_controller.text.length}/9000',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<AddReviewsBloc, AddReviewsState>(
                bloc: _blocReviews,
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      if (_controller.text.isNotEmpty) {
                        _blocReviews.add(LoadAddReviewsEvent(
                            token: token,
                            user: widget.products.owner.id,
                            product: widget.products.id,
                            rating: _ratingNotifier.value,
                            text: _controller.text));
                        eventBus.fire(UpdateIvan());
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Все поля должны быть заполнены!')),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          color: _controller.text.isNotEmpty ? ColorRes.orange : ColorRes.greyHint,
                          borderRadius: BorderRadius.circular(6)),
                      child: const Text('Подтвердить'),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                      color: ColorRes.grey,
                      borderRadius: BorderRadius.circular(6)),
                  child: const Text('Отменить'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigate(index: 0),
    ));
  }
}
