import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:russsia_carrot/data/model/reviews_model.dart';
import '../../../generated/assets.dart';
import '../../../theme/color_res.dart';

class ListReviews extends StatelessWidget {
  const ListReviews({super.key, required this.reviews});

  final ResultReviews reviews;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 26, right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
          color: ColorRes.grey, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: reviews.user.image.isEmpty
                      ? Image.asset(Assets.imagesPerson)
                      : Image.network(reviews.user.image)),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${reviews.user.firstName} ${reviews.user.lastName}",
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w700)),
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
                  SizedBox(
                    width: 200,
                    child: Text(
                      reviews.text,
                      style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff6F6F6F)),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
