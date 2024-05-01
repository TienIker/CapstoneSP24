import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/helper/weather_helper.dart';
import 'package:sharing_cafe/provider/home_provider.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_detail/blog_detail_screen.dart';

import 'package:sharing_cafe/view/screens/home/components/blog_card.dart';
import 'package:sharing_cafe/view/screens/events/event_detail/event_detail_screen.dart';
//import 'package:sharing_cafe/view/screens/home/components/matching_banner.dart';
import 'package:sharing_cafe/view/screens/home/components/event_card_2.dart';
import 'package:sharing_cafe/view/screens/notification/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  bool _isLoadingSuggestEvents = false;
  bool _isLoading = false;

  @override
  void initState() {
    loadSuggestEvents();
    setState(() {
      _isLoading = true;
    });
    Provider.of<HomeProvider>(context, listen: false)
        .getBlogs()
        .then((_) => setState(() {
              _isLoading = false;
            }));
    super.initState();
  }

  void loadSuggestEvents() {
    setState(() {
      _isLoadingSuggestEvents = true;
    });
    Provider.of<HomeProvider>(context, listen: false)
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
              Text('Sharing Café',
                  style: heading2Style.copyWith(color: kPrimaryColor)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_outlined,
                size: 24,
              ),
              onPressed: () {
                Navigator.pushNamed(context, NotificationScreen.routeName);
              },
            ),
          ],
        ),
        body: Consumer<HomeProvider>(builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                //const DiscountBanner(),
                // TextButton(
                //   onPressed: () {
                //     // Handle attend action
                //   },
                //   style: ButtonStyle(
                //     backgroundColor:
                //         MaterialStateColor.resolveWith((states) => Colors.white),
                //   ),
                //   child: const Text(
                //     'Tham gia',
                //     style: TextStyle(
                //         color: kPrimaryColor, fontWeight: FontWeight.bold),
                //   ),
                // ),
                FutureBuilder(
                  future: WeatherHelper().getWeather(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return Container();
                    }
                    var weatherData = snapshot.data;
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/weather.jpg'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Thời tiết",
                            style: heading2Style,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Nhiệt độ: ${WeatherHelper().kelvinToCelsius(weatherData['main']['temp'])}°C",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: kPrimaryColor,
                                ),
                              ),
                              Text(
                                "Độ ẩm: ${weatherData['main']['humidity']}%",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Text(
                  "Sự kiện thịnh hành",
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
                              location: event.location ?? "",
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
                      "Blogs phổ biến",
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
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.blogs.length,
                        itemBuilder: (context, index) {
                          var blog = value.blogs[index];
                          return BlogCard(
                            imageUrl: blog.image,
                            title: blog.title,
                            dateTime:
                                DateTimeHelper.formatDateTime(blog.createdAt),
                            avtUrl: blog.ownerAvatar ??
                                'https://picsum.photos/id/200/200/300',
                            ownerName: blog.ownerName,
                            time: DateTimeHelper.howOldFrom(blog.createdAt),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, BlogDetailScreen.routeName,
                                  arguments: {
                                    'id': blog.blogId,
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
