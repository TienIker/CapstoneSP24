import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/model/schedule_model.dart';
import 'package:sharing_cafe/service/chat_service.dart';
import 'package:sharing_cafe/view/components/form_field.dart';

class AppointmentHistoryScreen extends StatefulWidget {
  static String routeName = "appointment-history";
  const AppointmentHistoryScreen({super.key});

  @override
  State<AppointmentHistoryScreen> createState() =>
      _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  Future<bool> sendFeedback(
      String scheduleId, String content, int rating) async {
    if (content.isEmpty) {
      ErrorHelper.showError(message: "Vui lòng nhập cảm nhận của bạn");
      return false;
    }
    if (rating < 1) {
      ErrorHelper.showError(message: "Vui lòng chọn đánh giá");
      return false;
    }
    try {
      return await ChatService().sendFeedback(scheduleId, content, rating);
    } catch (e) {
      ErrorHelper.showError(message: e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var loggedUserId = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch sử hẹn',
          style: heading2Style,
        ),
      ),
      body: FutureBuilder(
          future: ChatService().getScheduleHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("Bạn chưa có cuộc hẹn nào"),
              );
            }
            var histories = snapshot.data as List<ScheduleModel>;
            return ListView.builder(
              itemCount: histories.length,
              itemBuilder: (context, index) {
                var history = histories[index];
                var canRating = history.rating == null ||
                    history.rating!.isEmpty ||
                    !history.rating!
                        .any((element) => element.userId == loggedUserId);
                var isFuture = history.date.isAfter(DateTime.now());
                var status = history.isAccept == null
                    ? "Đang chờ"
                    : history.isAccept!
                        ? "Đã chấp nhận"
                        : "Đã từ chối";
                final TextEditingController commentController =
                    TextEditingController();
                var ratingPoint = 0;
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kPrimaryLightColor,
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(DateTimeHelper.formatDateTime(history.date)),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Lịch hẹn: ${history.content}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${history.senderName} - ${history.receiverName}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // trang thai
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Trạng thái: $status",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: status == "Đã chấp nhận"
                              ? Colors.green
                              : status == "Đã từ chối"
                                  ? Colors.red
                                  : Colors.yellow[800],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Địa điểm: ${history.location}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // button submit rating
                      if (status == "Đã chấp nhận")
                        if (!isFuture)
                          canRating
                              ? SizedBox(
                                  height: 32,
                                  width: 200,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Đánh giá"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  KFormField(
                                                    hintText:
                                                        "Cảm nhận của bạn",
                                                    maxLines: 3,
                                                    controller:
                                                        commentController,
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  RatingBar.builder(
                                                    initialRating: 0,
                                                    itemCount: 5,
                                                    itemBuilder:
                                                        (context, index) {
                                                      switch (index) {
                                                        case 0:
                                                          return const Icon(
                                                            Icons
                                                                .sentiment_very_dissatisfied,
                                                            color: Colors.red,
                                                          );
                                                        case 1:
                                                          return const Icon(
                                                            Icons
                                                                .sentiment_dissatisfied,
                                                            color: Colors
                                                                .redAccent,
                                                          );
                                                        case 2:
                                                          return const Icon(
                                                            Icons
                                                                .sentiment_neutral,
                                                            color: Colors.amber,
                                                          );
                                                        case 3:
                                                          return const Icon(
                                                            Icons
                                                                .sentiment_satisfied,
                                                            color: Colors
                                                                .lightGreen,
                                                          );
                                                        case 4:
                                                          return const Icon(
                                                            Icons
                                                                .sentiment_very_satisfied,
                                                            color: Colors.green,
                                                          );
                                                        default:
                                                          return const Icon(
                                                            Icons
                                                                .sentiment_very_dissatisfied,
                                                            color: Colors.red,
                                                          );
                                                      }
                                                    },
                                                    onRatingUpdate: (rating) {
                                                      ratingPoint =
                                                          rating.toInt();
                                                    },
                                                  )
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
                                                    var res =
                                                        await sendFeedback(
                                                            history.scheduleId,
                                                            commentController
                                                                .text,
                                                            ratingPoint);
                                                    if (res) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Gửi đánh giá thành công");
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: const Text(
                                                      "Gửi đánh giá"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text("Đánh giá")),
                                )
                              : RatingList(history: history),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}

class RatingList extends StatefulWidget {
  const RatingList({
    super.key,
    required this.history,
  });

  final ScheduleModel history;

  @override
  State<RatingList> createState() => _RatingListState();
}

class _RatingListState extends State<RatingList> {
  bool _expand = false;

  toggleExpand() {
    setState(() {
      _expand = !_expand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleExpand,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_expand)
                  const Text(
                    'Xem đánh giá',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                IconButton(
                  onPressed: toggleExpand,
                  icon: Icon(_expand ? Icons.expand_less : Icons.expand_more),
                ),
              ],
            ),
            if (_expand)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.history.rating!.length,
                itemBuilder: (context, index) {
                  var rating = widget.history.rating![index];
                  return RatingView(rating: rating);
                },
              )
          ],
        ),
      ),
    );
  }
}

class RatingView extends StatefulWidget {
  const RatingView({
    super.key,
    required this.rating,
  });

  final Rating rating;

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  getIcon(String rating) {
    switch (rating) {
      case "1":
        return const Row(
          children: [
            Icon(
              Icons.sentiment_very_dissatisfied,
              color: Colors.red,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Rất không hài lòng",
              style: TextStyle(color: Colors.red),
            ),
          ],
        );
      case "2":
        return const Row(
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              color: Colors.redAccent,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Không hài lòng",
              style: TextStyle(color: Colors.redAccent),
            ),
          ],
        );
      case "3":
        return const Row(
          children: [
            Icon(
              Icons.sentiment_neutral,
              color: Colors.amber,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Bình thường",
              style: TextStyle(color: Colors.amber),
            ),
          ],
        );
      case "4":
        return const Row(
          children: [
            Icon(
              Icons.sentiment_satisfied,
              color: Colors.lightGreen,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Hài lòng",
              style: TextStyle(color: Colors.lightGreen),
            ),
          ],
        );
      case "5":
        return const Row(
          children: [
            Icon(
              Icons.sentiment_very_satisfied,
              color: Colors.green,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Rất hài lòng",
              style: TextStyle(color: Colors.green),
            ),
          ],
        );
      default:
        return const Row(
          children: [
            Icon(
              Icons.sentiment_very_dissatisfied,
              color: Colors.red,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Rất không hài lòng",
              style: TextStyle(color: Colors.red),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                "Người đánh giá: ${widget.rating.userName}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            const Text(
              "Đánh giá: ",
              style: TextStyle(
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            getIcon(widget.rating.rating ?? "")
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "Cảm nhận: ${widget.rating.content}",
          style: const TextStyle(
            fontSize: 14,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
