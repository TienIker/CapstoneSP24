import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/provider/user_profile_provider.dart';
import 'package:sharing_cafe/service/user_profile_service.dart';
import 'package:sharing_cafe/view/screens/matching/components/profile_card.dart';

class PreviewMyProfileScreen extends StatefulWidget {
  static String routeName = "/preview_my_profile";
  const PreviewMyProfileScreen({super.key});

  @override
  State<PreviewMyProfileScreen> createState() => _PreviewMyProfileScreenState();
}

class _PreviewMyProfileScreenState extends State<PreviewMyProfileScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<UserProfileProvider>(context, listen: false)
        .getUserProfile()
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
        title: Row(
          children: [
            Image.asset(
              'assets/images/cafe.png',
              height: 20,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text('Xem trước', style: heading2Style),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Consumer<UserProfileProvider>(builder: (context, value, child) {
              var profiles = value.userProfile;

              return Stack(children: [
                Column(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showBottomSheet(
                            context: context,
                            shape: const Border(top: BorderSide.none),
                            builder: (context) {
                              return FutureBuilder(
                                  future: UserProfileService().getUserProfile(),
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
                                        child: Text("Không có thông tin"),
                                      );
                                    }
                                    // create jobs string with ,
                                    var jobs = info.problem.isNotEmpty
                                        ? info.problem
                                            .map((e) => e.problem)
                                            .join(", ")
                                        : "Không có";
                                    var unlikeTopics = info.problem.isNotEmpty
                                        ? info.unlikeTopic
                                            .map((e) => e.unlikeTopic)
                                            .join(", ")
                                        : "Không có";
                                    var favoriteDrinks = info.problem.isNotEmpty
                                        ? info.favoriteDrink
                                            .map((e) => e.favoriteDrink)
                                            .join(", ")
                                        : "Không có";
                                    var freeTime = info.problem.isNotEmpty
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
                                                image: profiles.profileAvatar,
                                                name: profiles.userName,
                                                description: profiles.story,
                                                age: profiles.age,
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
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Row(
                                                    children: [
                                                      Icon(Icons.search),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text("Đang tìm kiếm")
                                                    ],
                                                  ),
                                                  Text(
                                                    info.purpose ?? "",
                                                    style: heading2Style,
                                                  )
                                                ],
                                              ),
                                            ),
                                            if (info.story != null)
                                              const SizedBox(
                                                height: 8,
                                              ),
                                            Visibility(
                                              visible: info.story != null,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: kPrimaryLightColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Row(
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
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  const Row(
                                                    children: [
                                                      Icon(Icons
                                                          .location_on_outlined),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text("Cách xa 0m")
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.home_outlined),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "Đang sống tại ${info.address}",
                                                          overflow: TextOverflow
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
                                                          overflow: TextOverflow
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
                                                          overflow: TextOverflow
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Row(
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
                                                          overflow: TextOverflow
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
                                                    children: info.interest
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
                            },
                          );
                        },
                        child: Stack(
                          children: [
                            ProfileCard(
                              image: profiles.profileAvatar,
                              name: profiles.userName,
                              description: profiles.story,
                              age: profiles.age,
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
              ]);
            }),
    );
  }
}
