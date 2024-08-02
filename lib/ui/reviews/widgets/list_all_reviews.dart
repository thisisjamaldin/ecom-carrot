import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:russsia_carrot/data/model/reviews_model.dart';
import '../../../generated/assets.dart';

class ListAllReviews extends StatelessWidget {
  const ListAllReviews({super.key, required this.reviews});

  final ResultReviews reviews;

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString).toLocal();
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      DateFormat timeFormat = DateFormat('Сегодня, HH:mm');
      return timeFormat.format(dateTime);
    } else {
      DateFormat dateFormat = DateFormat('dd MMM, HH:mm');
      return dateFormat.format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 26,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                      children: [
                        Text("${reviews.user.firstName} ${reviews.user.lastName}",
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w700)),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          formatDate(reviews.createdAt.toString()),
                          style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF6F6F6F)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          'ставит',
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        ...List.generate(
                          reviews.rating,
                          (index) => SvgPicture.asset(
                            Assets.iconsStar,
                            width: 8,
                            height: 8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                     Text(
                      reviews.text,
                      style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff6F6F6F)),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Divider(height: 1, color: Color(0xFF27262A))),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
