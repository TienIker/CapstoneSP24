import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/enums.dart';
import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/model/notification_model.dart';
import 'package:sharing_cafe/service/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName = "notification";
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thông báo",
          style: heading2Style,
        ),
      ),
      body: FutureBuilder(
        future: NotificationService().getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var data = snapshot.data as List<NotificationModel>;
              if (data.isEmpty) {
                return const Center(
                  child: Text("Không có thông báo"),
                );
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: data[index].status == NotificationStatus.read
                          ? Colors.grey[200]
                          : Colors.white,
                    ),
                    child: ListTile(
                      title: Text(
                        data[index].content,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          DateTimeHelper.howOldFrom(data[index].createdAt)),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("Không có thông báo"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
