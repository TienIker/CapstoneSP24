import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/provider/event_provider.dart';
import 'package:sharing_cafe/view/screens/events/create_event/create_event_screen.dart';
import 'package:sharing_cafe/view/screens/events/event_detail/event_detail_screen.dart';
import 'package:sharing_cafe/view/screens/events/event_list/components/event_card_2.dart';
import 'package:sharing_cafe/view/screens/events/my_event/my_event_screen.dart';
import 'package:sharing_cafe/view/screens/events/search/search_screen.dart';

import 'components/event_card.dart';

class EventListScreen extends StatefulWidget {
  static String routeName = "/events";
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  bool _isLoadingNewEvents = false;
  bool _isLoadingSuggestEvents = false;

  @override
  void initState() {
    loadSuggestEvents();
    loadNewEvents();
    super.initState();
  }

  void loadNewEvents() {
    setState(() {
      _isLoadingNewEvents = true;
    });
    Provider.of<EventProvider>(context, listen: false).getNewEvents().then((_) {
      setState(() {
        _isLoadingNewEvents = false;
      });
    });
  }

  void loadSuggestEvents() {
    setState(() {
      _isLoadingSuggestEvents = true;
    });
    Provider.of<EventProvider>(context, listen: false)
        .getSuggestEvents()
        .then((_) {
      setState(() {
        _isLoadingSuggestEvents = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/images/cafe.png',
                height: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              Text('Sự kiện',
                  style: heading2Style.copyWith(color: kPrimaryColor)),
            ],
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
            IconButton(
              icon: const Icon(
                Icons.calendar_month_outlined,
                size: 24,
              ),
              onPressed: () {
                Navigator.pushNamed(context, MyEventScreen.routeName);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.search,
                size: 24,
              ),
              onPressed: () {
                Navigator.pushNamed(context, SearchScreen.routeName);
              },
            ),
          ],
        ),
        body: Consumer<EventProvider>(builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const Text(
                  "Đề xuất",
                  style: heading2Style,
                ),
                SizedBox(
                  height: 333,
                  child: _isLoadingSuggestEvents
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.suggestEvents.length,
                          itemBuilder: (context, index) {
                            var event = value.suggestEvents[index];
                            return EventCard2(
                              imageUrl: event.backgroundImage,
                              title: event.title,
                              dateTime: DateTimeHelper.formatDateTime(
                                  event.timeOfEvent),
                              address: event.address ?? "",
                              attendeeCount: event.participantsCount,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, EventDetailScreen.routeName,
                                    arguments: {
                                      'id': event.eventId,
                                    });
                              },
                            );
                          },
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sự kiện mới",
                      style: heading2Style,
                    ),
                    IconButton(
                        onPressed: () {/* ... */},
                        icon: const Icon(
                          Icons.arrow_forward,
                          size: 24,
                          color: kPrimaryColor,
                        ))
                  ],
                ),
                _isLoadingNewEvents
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.newEvents.length,
                        itemBuilder: (context, index) {
                          var event = value.newEvents[index];
                          return EventCard(
                            imageUrl: event.backgroundImage,
                            title: event.title,
                            dateTime: DateTimeHelper.formatDateTime(
                                event.timeOfEvent),
                            address: event.address ?? "",
                            attendeeCount: event.participantsCount,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, EventDetailScreen.routeName,
                                  arguments: {
                                    'id': event.eventId,
                                  });
                            },
                          );
                        },
                      ),
              ],
            ),
          );
        }));
  }
}
