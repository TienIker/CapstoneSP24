import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/enums.dart';
import 'package:sharing_cafe/provider/match_provider.dart';
import 'package:sharing_cafe/view/screens/friends/friends_screen.dart';
import 'package:sharing_cafe/view/screens/friends/pending_screen.dart';
import 'package:sharing_cafe/view/screens/matching/components/profile_card.dart';

class SwipeScreen extends StatefulWidget {
  static String routeName = "/swipe";
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  bool _isLoading = false;
  bool _showIcon = false;
  bool _isLikeIcon = true;
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

  showIcon({isLike = true}) async {
    setState(() {
      _showIcon = true;
      _isLikeIcon = isLike;
    });
    await Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showIcon = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey filterButtonKey = GlobalKey();
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
            Text('Kết nối',
                style: heading2Style.copyWith(color: kPrimaryColor)),
          ],
        ),
        actions: [
          //filter
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            key: filterButtonKey,
            onPressed: () {
              // Get the RenderBox object
              final RenderBox renderBox = filterButtonKey.currentContext
                  ?.findRenderObject() as RenderBox;
              final Offset offset = renderBox.localToGlobal(Offset.zero);

              // Calculate the position for the menu
              final RelativeRect position = RelativeRect.fromLTRB(
                  offset.dx, // This is the left position.
                  offset.dy, // This is the top position.
                  30, // This is the right position (not used here).
                  0 // This is the bottom position (not used here).
                  );
              showMenu(
                context: context,
                position: position,
                items: [
                  PopupMenuItem(
                    value: "age",
                    onTap: () {},
                    child: const Text("Theo tuổi"),
                  ),
                  PopupMenuItem(
                    value: "distance",
                    onTap: () {},
                    child: const Text(
                      "Theo khoảng cách",
                    ),
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.pending_actions),
            onPressed: () {
              Navigator.pushNamed(context, PendingScreen.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.supervisor_account),
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
                                    return Consumer<MatchProvider>(
                                        builder: (context, value, child) {
                                      return FutureBuilder(
                                          future: value.getProfileInfo(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child: CircularProgressIndicator
                                                    .adaptive(),
                                              );
                                            }
                                            var info = snapshot.data;
                                            if (info == null) {
                                              return const Center(
                                                child:
                                                    Text("Không có thông tin"),
                                              );
                                            }
                                            // create jobs string with ,
                                            var jobs = info.problem.isNotEmpty
                                                ? info.problem
                                                    .map((e) => e.problem)
                                                    .join(", ")
                                                : "Không có";
                                            var unlikeTopics = info
                                                    .problem.isNotEmpty
                                                ? info.unlikeTopic
                                                    .map((e) => e.unlikeTopic)
                                                    .join(", ")
                                                : "Không có";
                                            var favoriteDrinks = info
                                                    .problem.isNotEmpty
                                                ? info.favoriteDrink
                                                    .map((e) => e.favoriteDrink)
                                                    .join(", ")
                                                : "Không có";
                                            var freeTime =
                                                info.problem.isNotEmpty
                                                    ? info.freeTime
                                                        .map((e) => e.freeTime)
                                                        .join(", ")
                                                    : "Không có";

                                            return SizedBox(
                                              height: 800,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 500,
                                                      child: ProfileCard(
                                                        image: profiles
                                                            .first.image,
                                                        name:
                                                            profiles.first.name,
                                                        description: profiles
                                                            .first.description,
                                                        age: profiles.first.age,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            kPrimaryLightColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Row(
                                                            children: [
                                                              Icon(
                                                                  Icons.search),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                  "Đang tìm kiếm")
                                                            ],
                                                          ),
                                                          Text(
                                                            info.purpose ?? "",
                                                            style:
                                                                heading2Style,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    if (info.story != null)
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                    Visibility(
                                                      visible:
                                                          info.story != null,
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              kPrimaryLightColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                        ),
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Row(
                                                              children: [
                                                                Icon(Icons
                                                                    .format_quote_rounded),
                                                                SizedBox(
                                                                  width: 4,
                                                                ),
                                                                Text(
                                                                    "Câu chuyện",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold))
                                                              ],
                                                            ),
                                                            Text(
                                                              info.story ?? "",
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            kPrimaryLightColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .info_outline),
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
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(Icons
                                                                  .location_on_outlined),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                  "Cách xa ${info.distance}")
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(Icons
                                                                  .home_outlined),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  "Đang sống tại ${info.address}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            kPrimaryLightColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .info_outline),
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
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          const Row(
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
                                                              const SizedBox(
                                                                width: 27,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  jobs,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Row(
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
                                                              const SizedBox(
                                                                width: 27,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  unlikeTopics,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Row(
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
                                                              const SizedBox(
                                                                width: 27,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  favoriteDrinks,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .park_outlined),
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
                                                              const SizedBox(
                                                                width: 27,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                    info.favoriteLocation ??
                                                                        ""),
                                                              ),
                                                            ],
                                                          ),
                                                          const Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .free_breakfast_outlined),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  "Thời gian rảnh rỗi",
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
                                                              const SizedBox(
                                                                width: 27,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  freeTime,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            kPrimaryLightColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
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
                                                            children: info
                                                                .interest
                                                                .map((e) => Chip(
                                                                    label: Text(e
                                                                        .interestName
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
                                          });
                                    });
                                  },
                                );
                              },
                              child: Stack(
                                children: [
                                  ProfileCard(
                                    image: profiles.first.image,
                                    name: profiles.first.name,
                                    description: profiles.first.description,
                                    age: profiles.first.age,
                                  ),
                                  if (_showIcon)
                                    Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                          height: 200,
                                          width: 200,
                                          child: Lottie.asset(
                                            _isLikeIcon
                                                ? 'assets/animations/like.json'
                                                : 'assets/animations/dislike.json',
                                            fit: BoxFit.cover,
                                            repeat: false,
                                          )),
                                    ),
                                ],
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
                                    await showIcon(isLike: false);
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
                                    await showIcon(isLike: true);
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
