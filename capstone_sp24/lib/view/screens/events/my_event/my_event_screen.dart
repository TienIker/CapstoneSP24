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
                      return EventCard(
                        imageUrl: events[index].backgroundImage,
                        title: events[index].title,
                        dateTime: DateTimeHelper.formatDateTime(
                            events[index].timeOfEvent),
                        location: events[index].location ?? "",
                        attendeeCount: events[index].participantsCount,
                        onTap: () {
                          Navigator.pushNamed(
                              context, EventDetailScreen.routeName,
                              arguments: {
                                'id': events[index].eventId,
                              });
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
