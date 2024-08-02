import 'package:intl/intl.dart';
import 'package:russsia_carrot/data/model/favorites_model.dart';
import 'package:russsia_carrot/generated/assets.dart';
import 'package:russsia_carrot/theme/color_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListFavorite extends StatelessWidget {
  const ListFavorite({super.key, required this.favorites});

  final ResultFavorites favorites;

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
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: ColorRes.grey,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 82,
                      width: 82,
                      child: Image.network(favorites.productData.photo),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          favorites.productData.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text(
                              '${double.parse(favorites.productData.price).toInt()} ₩',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Договорная',
                              style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w400,
                                  color: ColorRes.orange),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          favorites.productData.address,
                          style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: ColorRes.orange),
                        ),
                        Text(
                          formatDate(
                              favorites.productData.createdAt.toString()),
                          style: const TextStyle(fontSize: 8),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(Assets.iconsRedHeart),
                    const SizedBox(width: 16)
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10)
      ],
    );
  }
}
