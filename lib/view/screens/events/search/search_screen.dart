import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/provider/event_provider.dart';
import 'package:sharing_cafe/view/screens/events/event_detail/event_detail_screen.dart';
import 'package:sharing_cafe/view/screens/events/event_list/components/event_card.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = "/search";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, eventProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
              color: kFormFieldColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Tìm kiếm',
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
              onSubmitted: (value) async {
                await eventProvider.search(value);
                eventProvider.insertSearchHistry(value);
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: eventProvider.searchEvents.isNotEmpty
              ? ListView.builder(
                  itemCount: eventProvider.searchEvents.length,
                  itemBuilder: (context, index) {
                    return EventCard(
                      imageUrl:
                          eventProvider.searchEvents[index].backgroundImage,
                      title: eventProvider.searchEvents[index].title,
                      dateTime: DateTimeHelper.formatDateTime(
                          eventProvider.searchEvents[index].timeOfEvent),
                      address: eventProvider.searchEvents[index].address ?? "",
                      attendeeCount:
                          eventProvider.searchEvents[index].participantsCount,
                      onTap: () {
                        Navigator.pushNamed(
                            context, EventDetailScreen.routeName,
                            arguments: {
                              'id': eventProvider.searchEvents[index].eventId,
                            });
                      },
                    );
                  },
                )
              : Column(
                  children: <Widget>[
                    Visibility(
                      visible: eventProvider.searchHistory.isNotEmpty,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Tìm kiếm trước đó',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () =>
                              eventProvider.removeAllSearchHistory(),
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: eventProvider.searchHistory.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              eventProvider.searchHistory[index],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey[600]),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () =>
                                  eventProvider.removeFromSearchHistory(
                                      eventProvider.searchHistory[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
