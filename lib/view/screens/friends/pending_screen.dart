// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/enums.dart';
import 'package:sharing_cafe/provider/friends_provider.dart';
import 'package:sharing_cafe/service/match_service.dart';
import 'package:sharing_cafe/view/screens/matching/components/profile_card.dart';

class PendingScreen extends StatefulWidget {
  static const routeName = "/pending";
  const PendingScreen({super.key});
  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<FriendsProvider>(context, listen: false)
        .getListFriends(pending: true)
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
          'Đang chờ',
          style: heading2Style,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<FriendsProvider>(
                builder: (context, value, child) {
                  var matches = value.friends;
                  return matches.isEmpty
                      ? const Center(
                          child: Text("Chưa có lời mời nào"),
                        )
                      : ListView.builder(
                          itemCount: matches.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                showBottomSheet(
                                  context: context,
                                  shape: const Border(top: BorderSide.none),
                                  builder: (context) {
                                    return FutureBuilder(
                                        future: MatchService().getProfileInfo(
                                            matches[index].userId),
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
                                          var unlikeTopics =
                                              info.problem.isNotEmpty
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
                                                  Stack(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 500,
                                                            child: ProfileCard(
                                                              image: info
                                                                  .profileAvatar,
                                                              name:
                                                                  info.userName,
                                                              description:
                                                                  info.story,
                                                              age: info.age,
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
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: <Widget>[
                                                                FloatingActionButton(
                                                                  heroTag:
                                                                      "dislike",
                                                                  onPressed:
                                                                      () async {
                                                                    var userName =
                                                                        matches[index]
                                                                            .userName;
                                                                    await value.likeOrUnlike(
                                                                        matches[index]
                                                                            .userId,
                                                                        MatchStatus
                                                                            .dislike);
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Đã từ chối $userName");
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  child: const Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                                FloatingActionButton(
                                                                  heroTag:
                                                                      "like",
                                                                  onPressed:
                                                                      () async {
                                                                    var userName =
                                                                        matches[index]
                                                                            .userName;
                                                                    await value.likeOrUnlike(
                                                                        matches[index]
                                                                            .userId,
                                                                        MatchStatus
                                                                            .pending);
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Đã kết bạn với $userName");
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  child: const Icon(
                                                                      Icons
                                                                          .favorite,
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: kPrimaryLightColor,
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
                                                            Icon(Icons.search),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                                "Đang tìm kiếm")
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
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: kPrimaryLightColor,
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
                                                      color: kPrimaryLightColor,
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
                                                      color: kPrimaryLightColor,
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
                                  },
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        matches[index].profileAvatar),
                                  ),
                                  title: Text(matches[index].userName),
                                  subtitle: Text(matches[index].bio),
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
    );
  }
}
