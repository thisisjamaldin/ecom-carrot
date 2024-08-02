import 'package:flutter/material.dart';

import '../../../generated/assets.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CategoryImage extends StatelessWidget {
  const CategoryImage({
    super.key,
    required this.title,
    required this.image,
  });

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(200),
          ),
          child: image.isEmpty
              ? Image.asset(
                  Assets.imagesShorts,
                  fit: BoxFit.fill,
                )
              : Image.network(
                  image,
                  fit: BoxFit.fill,
                ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 76,
          child: AutoSizeText(
            title,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
