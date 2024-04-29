import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/helper/shared_prefs_helper.dart';
import 'package:sharing_cafe/provider/event_provider.dart';
import 'package:sharing_cafe/service/event_service.dart';
import 'package:sharing_cafe/view/components/form_field.dart';

class EventDetailScreen extends StatefulWidget {
  static String routeName = "/event-detail";
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isLoading = false;
  bool _canJoinEvent = true;
  String _loggedUser = "";
  String id = "";

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    SharedPrefHelper.getUserId().then((value) {
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      id = arguments['id'];
      _loggedUser = value;
    }).then((_) => Provider.of<EventProvider>(context, listen: false)
        .getEventDetails(id)
        .then((value) => EventService().getEventParticipants(id))
        .then((value) => _canJoinEvent =
            !value.any((element) => element.userId == _loggedUser))
        .then((_) => setState(() {
              _isLoading = false;
            })));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Consumer<EventProvider>(builder: (context, value, child) {
              var eventDetails = value.eventDetails;
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 250.0,
                    floating: false,
                    pinned: true,
                    snap: false,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        child: Image.network(
                          eventDetails.backgroundImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    iconTheme: const IconThemeData(color: Colors.white),
                    actions: [
                      IconButton(
                          onPressed: () {
                            showMenu(
                                context: context,
                                position:
                                    const RelativeRect.fromLTRB(100, 50, 0, 0),
                                items: [
                                  PopupMenuItem(
                                    onTap: () {
                                      final TextEditingController
                                          reportContentController =
                                          TextEditingController();
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Báo cáo"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                      "Bạn có chắc chắn muốn báo cáo bài viết này?"),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  //text field for report content
                                                  KFormField(
                                                    hintText:
                                                        "Nội dung báo cáo",
                                                    maxLines: 3,
                                                    controller:
                                                        reportContentController,
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Hủy"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    if (reportContentController
                                                        .text.isEmpty) {
                                                      ErrorHelper.showError(
                                                          message:
                                                              "Vui lòng nhập nội dung báo cáo");
                                                      return;
                                                    }
                                                    var loggedUser =
                                                        await SharedPrefHelper
                                                            .getUserId();
                                                    var res = await EventService()
                                                        .reportEvent(
                                                            reporterId:
                                                                loggedUser,
                                                            eventId:
                                                                eventDetails
                                                                    .eventId,
                                                            content:
                                                                reportContentController
                                                                    .text);
                                                    if (res) {
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text("Báo cáo"),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: const Text("Báo cáo"),
                                  ),
                                ]);
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                eventDetails.title,
                                textAlign: TextAlign.center,
                                style: headingStyle,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _canJoinEvent
                                      ? TextButton(
                                          onPressed: () async {
                                            var res = await EventService()
                                                .joinEvent(
                                                    eventDetails.eventId);
                                            if (res) {
                                              setState(() {
                                                _canJoinEvent = false;
                                              });
                                            }
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => kPrimaryColor),
                                            padding: MaterialStateProperty
                                                .resolveWith((states) =>
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 32.0)),
                                          ),
                                          child: const Text(
                                            'Tham gia',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                var res = await EventService()
                                                    .leaveEvent(
                                                        eventDetails.eventId);
                                                if (res) {
                                                  setState(() {
                                                    _canJoinEvent = true;
                                                  });
                                                }
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateColor
                                                        .resolveWith((states) =>
                                                            kErrorColor),
                                                padding: MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 32.0)),
                                              ),
                                              child: const Text(
                                                'Hủy tham gia',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     // Handle attend action
                                  //   },
                                  //   style: ButtonStyle(
                                  //     backgroundColor:
                                  //         MaterialStateColor.resolveWith(
                                  //             (states) => kPrimaryLightColor),
                                  //     padding:
                                  //         MaterialStateProperty.resolveWith(
                                  //             (states) =>
                                  //                 const EdgeInsets.symmetric(
                                  //                     horizontal: 24.0)),
                                  //   ),
                                  //   child: const Text(
                                  //     'Kết nối nhóm',
                                  //     style: TextStyle(
                                  //         color: kPrimaryColor,
                                  //         fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     // Handle attend action
                                  //   },
                                  //   style: ButtonStyle(
                                  //     backgroundColor:
                                  //         MaterialStateColor.resolveWith(
                                  //             (states) => kPrimaryLightColor),
                                  //   ),
                                  //   child: const Icon(
                                  //     Icons.more_horiz,
                                  //     color: kPrimaryColor,
                                  //   ),
                                  // ),
                                ],
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(
                                  Icons.access_time_filled,
                                  color: kSecondaryColor,
                                ),
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  DateTimeHelper.formatDateTime2(
                                          eventDetails.timeOfEvent) +
                                      " - ${DateTimeHelper.formatDateTime2(eventDetails.endOfEvent) ?? ""}",
                                ),
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.person,
                                  color: kSecondaryColor,
                                ),
                                title: Text.rich(
                                  TextSpan(text: 'Sự kiện của ', children: [
                                    TextSpan(
                                        text: eventDetails.organizationName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ]),
                                ),
                                contentPadding: EdgeInsets.zero,
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.location_on_rounded,
                                  color: kSecondaryColor,
                                ),
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  eventDetails.location ?? "",
                                ),
                                subtitle: Text(
                                  eventDetails.address ?? "",
                                  style: const TextStyle(
                                    color: kSecondaryColor,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.check_box,
                                  color: kSecondaryColor,
                                ),
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${eventDetails.participantsCount} Người sẽ tham gia',
                                ),
                              ),
                              const Divider(),
                              const Text(
                                'Chi tiết sự kiện',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                eventDetails.description ?? "",
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              // Add more widgets for other details if needed
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
    );
  }
}
