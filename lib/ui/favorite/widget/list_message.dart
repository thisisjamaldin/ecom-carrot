import 'package:flutter/material.dart';
import 'package:russsia_carrot/data/model/chat.dart';

import '../../../generated/assets.dart';
import '../../../theme/color_res.dart';

class ListMessage extends StatelessWidget {
  const ListMessage({super.key, required this.productRoom});

  final ProductInRoomModel productRoom;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: ColorRes.grey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              SizedBox(
                height: 82,
                width: 82,
                child: Image.network(
                  productRoom.photos?.first.photo ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${productRoom.name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${productRoom.ownerName}',
                    style: const TextStyle(fontSize: 8, color: ColorRes.orange),
                  ),
                  // const SizedBox(height: 2),
                  // RichText(
                  //   text: const TextSpan(
                  //     style:
                  //         TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                  //     children: [
                  //       TextSpan(text: 'Вы: '),
                  //       TextSpan(
                  //           text: 'Уступите за 350 000?',
                  //           style: TextStyle(fontWeight: FontWeight.w500))
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // const Text(
                  //   'Сегодня, 15:30',
                  //   style: TextStyle(
                  //     fontSize: 8,
                  //   ),
                  // ),
                ],
              )
            ]),
          ],
        ));
  }
}
