import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/provider/event_provider.dart';
import 'package:sharing_cafe/view/screens/events/create_event/create_event_screen.dart';
import 'package:sharing_cafe/view/screens/events/event_detail/event_detail_screen.dart';
import 'package:sharing_cafe/view/screens/events/event_list/components/event_card.dart';

class MyEventScreen extends StatefulWidget {
  static String routeName = "/my-event";
  const MyEventScreen({super.key});

  @override
  State<MyEventScreen> createState() => _MyEventScreenState();
}

class _MyEventScreenState extends State<MyEventScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<EventProvider>(context, listen: false)
        .getMyEvents()
        .then((value) => setState(() {
              _isLoading = false;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sự kiện của bạn",
          style: heading2Style,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_box_outlined,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, CreateEventScreen.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Consumer<EventProvider>(
                builder: (context, value, child) {
                  var events = value.myEvents;
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      GlobalKey moreButtonKey = GlobalKey();
                      return EventCard(
                        imageUrl: events[index].backgroundImage,
                        title: events[index].title,
                        dateTime: DateTimeHelper.formatDateTime(
                            events[index].timeOfEvent),
                        address: events[index].address ?? "",
                        attendeeCount: events[index].participantsCount,
                        onTap: () {
                          Navigator.pushNamed(
                              context, EventDetailScreen.routeName,
                              arguments: {
                                'id': events[index].eventId,
                              });
                        },
                        moreButtonKey: moreButtonKey,
                        onMoreButtonClick: () {
                          // Get the RenderBox object
                          final RenderBox renderBox =
                              moreButtonKey.currentContext?.findRenderObject()
                                  as RenderBox;
                          final Offset offset =
                              renderBox.localToGlobal(Offset.zero);

                          // Calculate the position for the menu
                          final RelativeRect position = RelativeRect.fromLTRB(
                              offset.dx, // This is the left position.
                              offset.dy, // This is the top position.
                              30, // This is the right position (not used here).
                              0 // This is the bottom position (not used here).
                              );

                          // Show the menu
                          showMenu(
                            context: context,
                            position: position,
                            items: [
                              PopupMenuItem(
                                value: "edit",
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, CreateEventScreen.routeName,
                                      arguments: {'id': events[index].eventId});
                                },
                                child: const Text("Chỉnh sửa"),
                              ),
                              PopupMenuItem(
                                value: "delete",
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Xác nhận"),
                                        content: const Text(
                                            "Bạn có chắc chắn muốn xóa sự kiện này không?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Hủy"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Provider.of<EventProvider>(
                                                      context,
                                                      listen: false)
                                                  .deleteEvent(
                                                      events[index].eventId)
                                                  .then((value) {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: const Text("Xóa"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  "Xóa",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
