

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/model/products_model.dart';
import '../../../generated/assets.dart';
import '../../../theme/color_res.dart';

class ListRecommend extends StatelessWidget {
  ListRecommend({
    super.key,
    this.products,
    required this.clickFavorite,
  });

  final ResultProducts? products;
  Function() clickFavorite;

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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorRes.grey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: products!.photo.isEmpty
                      ? Image.asset(
                          Assets.imagesHeadphones,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.14,
                        )
                      : Image.network(
                          products!.photo,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.14,
                        )),
              Positioned(
                  right: 8,
                  top: 8,
                  child: GestureDetector(
                    onTap: clickFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: ColorRes.grey,
                      ),
                      child: Icon(
                        products!.favorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ))
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AutoSizeText(
              products?.name ?? 'Наушники Beatasdasds by Dre',
              maxLines: 2,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  "${double.parse(products?.price ?? '0').toInt()} ₩",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Договорная',
                  style: TextStyle(
                    color: ColorRes.orange,
                    fontWeight: FontWeight.w400,
                    fontSize: 8,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 8),
              Text(
                products?.address ?? 'Алматы',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: ColorRes.orange),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 8),
              Text(
                formatDate(products!.createdAt.toString()),
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ListRecommend2 extends StatelessWidget {
   ListRecommend2({
    super.key,
    required this.listProduct,
    required this.delete,
  });

  final ResultProducts? listProduct;
  Function() delete;


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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorRes.grey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: (listProduct?.photo ?? '').isEmpty
                    ? Image.asset(
                        Assets.imagesHeadphones,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.14,
                      )
                    : Image.network(
                        listProduct?.photo ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.14,
                      ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: delete,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      color: ColorRes.grey,
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AutoSizeText(
              listProduct?.name ?? '',
              maxLines: 1,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  "${double.parse(listProduct?.price ?? '').toInt()} ₩",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Договорная',
                  style: TextStyle(
                    color: ColorRes.orange,
                    fontWeight: FontWeight.w400,
                    fontSize: 8,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 8),
              Text(
                listProduct?.address ?? '',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: ColorRes.orange),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 8),
              Text(
                formatDate((listProduct?.createdAt ?? '').toString()),
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
