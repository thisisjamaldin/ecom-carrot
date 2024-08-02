import 'package:auto_route/annotations.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:russsia_carrot/generated/assets.dart';

import '../../../data/model/products_model.dart';
import '../../../theme/color_res.dart';

@RoutePage()
class PhotoDetailPage extends StatefulWidget {
  PhotoDetailPage({
    super.key,
    required this.photos,
  });

  List<Photo> photos;

  @override
  State<PhotoDetailPage> createState() => _PhotoDetailPageState();
}

class _PhotoDetailPageState extends State<PhotoDetailPage> {
  int selectedPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: selectedPage);
    _pageController.addListener(() {
      setState(() {
        selectedPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            itemCount: widget.photos.length,
            itemBuilder: (context, index) {
              return Image.network(
                widget.photos[index].photo,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorRes.greyWhite.withOpacity(0.5)),
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(Assets.iconsChevronLeft),
              ),
            ),
          ),
          Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: DotsIndicator(
                dotsCount: widget.photos.length,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                position: selectedPage,
                decorator: DotsDecorator(
                  color: ColorRes.grey,
                  activeColor: ColorRes.orange,
                  // activeSize: const Size.square(9.0),
                  // size: const Size(18.0, 9.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
