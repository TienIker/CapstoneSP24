import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/enums.dart';
import 'package:sharing_cafe/provider/match_provider.dart';
import 'package:sharing_cafe/view/screens/friends/friends_screen.dart';
import 'package:sharing_cafe/view/screens/matching/components/profile_card.dart';

class SwipeScreen extends StatefulWidget {
  static String routeName = "/swipe";
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<MatchProvider>(context, listen: false)
        .initListProfiles()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sharing Coffee",
          style: heading2Style,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.messenger_outline),
            onPressed: () {
              Navigator.pushNamed(context, FriendsScreen.routeName);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Consumer<MatchProvider>(builder: (context, value, child) {
              var profiles = value.profiles;

              return profiles.isEmpty
                  ? const Center(child: Text("Chưa có người dùng mới"))
                  : Stack(children: [
                      Column(
                        children: <Widget>[
                          Expanded(
                            // child: Swiper(
                            //   itemCount: profiles.length,
                            //   itemBuilder: (context, index) {
                            //     return ProfileCard(
                            //       image: profiles[index].image,
                            //       name: profiles[index].name,
                            //       description: profiles[index].description,
                            //       age: profiles[index].age,
                            //     );
                            //   },
                            //   layout: SwiperLayout.STACK,
                            //   loop: true,
                            //   itemWidth: MediaQuery.of(context).size.width,
                            //   itemHeight: MediaQuery.of(context).size.height,
                            //   onIndexChanged: (index) {
                            //     // When swipe right, selected user index is index - 1
                            //     // When swipe left, selected user index is index + 1
                            //     value.setCurrentProfileByIndex(index);
                            //   },
                            // ),
                            child: GestureDetector(
                              onTap: () {
                                showBottomSheet(
                                  context: context,
                                  shape: const Border(top: BorderSide.none),
                                  builder: (context) {
                                    return SizedBox(
                                      height: 800,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 500,
                                              child: ProfileCard(
                                                image: profiles.first.image,
                                                name: profiles.first.name,
                                                description:
                                                    profiles.first.description,
                                                age: profiles.first.age,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: kPrimaryLightColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              padding: const EdgeInsets.all(16),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.search),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text("Đang tìm kiếm")
                                                    ],
                                                  ),
                                                  Text(
                                                    "Mối quan hệ lâu dài",
                                                    style: heading2Style,
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: kPrimaryLightColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              padding: const EdgeInsets.all(16),
                                              child: const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons
                                                          .format_quote_rounded),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text("Câu chuyện",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  ),
                                                  Text(
                                                    "Câu chuyện về cuộc sống ",
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: kPrimaryLightColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              padding: const EdgeInsets.all(16),
                                              child: const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.info_outline),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "Thông tin chính",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons
                                                          .location_on_outlined),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text("Cách xa 16km")
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.home_outlined),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                          "Đang sống tại Hà Nội"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: kPrimaryLightColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              padding: const EdgeInsets.all(16),
                                              child: const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.info_outline),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "Thông tin cơ bản",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons
                                                          .question_mark_outlined),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "Bạn đang gặp khó khăn",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 27,
                                                      ),
                                                      Text("Công việc"),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons
                                                          .question_mark_outlined),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "Khi trò chuyện, bạn không muốn đề cập",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 27,
                                                      ),
                                                      Text("Hôn nhân"),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons
                                                          .local_drink_outlined),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "Thức uống yêu thích",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 27,
                                                      ),
                                                      Text("Cafe"),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.park_outlined),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "Địa điểm yêu thích",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 27,
                                                      ),
                                                      Text("Bamos coffe"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: kPrimaryLightColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Row(
                                                    children: [
                                                      Icon(Icons
                                                          .interests_outlined),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "Sở thích",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  // List chip
                                                  Wrap(
                                                    spacing: 6,
                                                    runSpacing: 0,
                                                    children: [
                                                      {
                                                        "name": "Du lịch",
                                                      },
                                                      {
                                                        "name": "Thể thao",
                                                      },
                                                      {
                                                        "name": "Đọc sách",
                                                      },
                                                      {
                                                        "name": "Nghe nhạc",
                                                      },
                                                      {
                                                        "name": "Xem phim",
                                                      },
                                                      {
                                                        "name": "Nấu ăn",
                                                      }
                                                    ]
                                                        .map((e) => Chip(
                                                            label: Text(e[
                                                                    "name"]
                                                                .toString())))
                                                        .toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: ProfileCard(
                                image: profiles.first.image,
                                name: profiles.first.name,
                                description: profiles.first.description,
                                age: profiles.first.age,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          )
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FloatingActionButton(
                                  heroTag: "dislike",
                                  onPressed: () async {
                                    await value
                                        .likeOrUnlike(MatchStatus.dislike);
                                  },
                                  backgroundColor: Colors.white,
                                  child: const Icon(Icons.close,
                                      color: Colors.red),
                                ),
                                FloatingActionButton(
                                  heroTag: "like",
                                  onPressed: () async {
                                    await value
                                        .likeOrUnlike(MatchStatus.pending);
                                  },
                                  backgroundColor: Colors.white,
                                  child: const Icon(Icons.favorite,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]);
            }),
    );
  }
}
