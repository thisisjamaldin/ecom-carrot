import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../features/bloc_notification/notification_bloc.dart';
import '../../../features/cubit_save_token/save_token_cubit.dart';
import '../../../generated/assets.dart';
import '../../../theme/color_res.dart';
import '../../bottom_navigate.dart';
import 'package:auto_size_text/auto_size_text.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  const NotificationPage({
    super.key,
    required this.isProfile,
  });

  final bool isProfile;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _blocNotification = NotificationBloc(GetIt.I<AbstractRepository>());
  late String token;
  final limit = ValueNotifier(100);

  @override
  void initState() {
    token = context.read<SaveTokenCubit>().state.token;
    _blocNotification
        .add(LoadNotificationEvent(token: token, limit: limit.value));
    super.initState();
  }

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text(
          'Уведомления',
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
      body: BlocBuilder<NotificationBloc, NotificationState>(
        bloc: _blocNotification,
        builder: (context, state) {
          if (state is LoadedNotificationState) {
            return ListView.builder(
              itemCount: state.notificationModel.results.length,
              itemBuilder: (context, index) {
                final list = state.notificationModel.results[index];
                return GestureDetector(
                  onTap: () {
                    // AutoRouter.of(context)
                    //     .push(const DetailNotificationRoute());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 6,
                              width: list.isRead ? 6 : 0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  color: ColorRes.orange),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.88,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                      children: [
                                        const TextSpan(
                                            text:
                                                'Вам пришел ответ на объявление: '),
                                        TextSpan(
                                          text: list.title,
                                          style: const TextStyle(
                                            color: ColorRes.orange,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: AutoSizeText(
                                            list.description,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        AutoSizeText(
                                          formatDate(list.createdAt.toString()),
                                          style: const TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          color: ColorRes.grey,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          if (state is ErrorNotificationState) {
            debugPrint(state.exception.toString());
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigate(index: widget.isProfile ? 3 : 0),
    );
  }
}
