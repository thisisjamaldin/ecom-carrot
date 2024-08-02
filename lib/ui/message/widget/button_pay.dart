import 'package:flutter/material.dart';

import '../../../theme/color_res.dart';

class ButtonPay extends StatelessWidget {
  ButtonPay({
    super.key,
    required this.title,
    required this.select,
    required this.onTap,
  });

  bool select;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 8),
        decoration: BoxDecoration(
            color: select ? ColorRes.orange : ColorRes.grey,
            borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            // const SizedBox(width: 16),
            // Visibility(
            //   visible: !select,
            //   child: Container(
            //     padding: const EdgeInsets.all(4),
            //     decoration: BoxDecoration(
            //       color: ColorRes.orange,
            //       borderRadius: BorderRadius.circular(200),
            //     ),
            //     child: const Text(
            //       '+1',
            //       style: TextStyle(fontSize: 6, fontWeight: FontWeight.w700),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
