import 'package:russsia_carrot/theme/color_res.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../data/model/categories_model.dart';
import '../../../utils/key.dart';

class ListCategory extends StatelessWidget {
  ListCategory({
    super.key,
    required this.clickItem,
    required this.category,
  });

  Function(String categiryId) clickItem;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: category.results.length,
      itemBuilder: (context, index) {
        final result = category.results[index];
        return GestureDetector(
          onTap: () => clickItem(result.id.toString()),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6), color: ColorRes.grey),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AutoSizeText(
                    result.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                    height: 56,
                    child: Image.network(
                        result.photo.isEmpty ? imgNet : result.photo))
              ],
            ),
          ),
        );
      },
    );
  }
}
