import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:russsia_carrot/data/model/chat.dart';
import 'package:russsia_carrot/generated/assets.dart';
import 'package:russsia_carrot/theme/color_res.dart';

class ListChat extends StatelessWidget {
  const ListChat({super.key, required this.msg, required this.myId});

  final MessagesModel msg;
  final int myId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Align(
              alignment: msg.userId == myId
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  color: Colors.grey,
                  child: msg.avatar != null
                      ? Image.network(
                          msg.avatar!,
                          width: 50,
                          height: 50,
                        )
                      : SvgPicture.asset(
                          Assets.iconsProfile,
                          width: 50,
                          height: 50,
                        ),
                ),
              )),
        ),
        Row(
          children: [
            if (msg.userId == myId)
              SizedBox(
                width: 100,
              ),
            Expanded(
                child: Align(
                    alignment: msg.userId == myId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (msg.userId == myId)
                          Text(
                              '${DateFormat('HH:mm').format(DateTime.parse(msg.createdAt ?? '').toLocal())}'),
                        if (msg.photo == null)
                          Container(
                              margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: msg.userId == myId
                                      ? ColorRes.orange
                                      : ColorRes.grey,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text('${msg.body}'))
                        else
                          Container(
                              margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: msg.userId == myId
                                      ? ColorRes.orange
                                      : ColorRes.grey,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Image.network(msg.photo!, width: 140, height: 140,)),
                        if (msg.userId != myId)
                          Text(
                              '${DateFormat('HH:mm').format(DateTime.parse(msg.createdAt ?? '').toLocal())}')
                      ],
                    ))),
            if (msg.userId != myId)
              SizedBox(
                width: 100,
              ),
          ],
        )
      ],
    );
  }
}
