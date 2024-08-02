import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../generated/assets.dart';

@RoutePage()
class HelpPage extends StatefulWidget {

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: const Text(
            'Помощь',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SvgPicture.asset(Assets.iconsChevronLeft),
            ),
          ),
        ),
        body: Center(
          child: GestureDetector(
            onTap: () async {
              final Uri params = Uri(
                scheme: 'mailto',
                path: 'rumorkovka.kr@gmail.com',
                query: 'subject=Помощь',
              );

              String url = params.toString();
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              color: Colors.black.withOpacity(0),
              child: RichText(textAlign: TextAlign.center,
                text: const TextSpan(children: [
                  TextSpan(
                      text:
                          'По всем вопросам связанным с работой приложения пишите на почту: '),
                  TextSpan(
                      text: 'rumorkovka.kr@gmail.com',
                      style: TextStyle(color: Colors.blueAccent))
                ]),
              ),
            ),
          ),
        ));
  }
}
