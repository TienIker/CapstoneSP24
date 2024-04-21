// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';

import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/helper/key_value_pair.dart';
import 'package:sharing_cafe/model/chat_message_model.dart';
import 'package:sharing_cafe/model/recommend_cafe.dart';
import 'package:sharing_cafe/provider/chat_provider.dart';
import 'package:sharing_cafe/service/chat_service.dart';
import 'package:sharing_cafe/view/components/date_time_picker.dart';
import 'package:sharing_cafe/view/components/form_field.dart';
import 'package:sharing_cafe/view/components/select_form.dart';

class ChatScreen extends StatefulWidget {
  static String routeName = "/chat";
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = true;
  String _userName = "Chat";
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero, () {
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      var id = arguments['id'];
      setState(() {
        _userName = arguments['name'];
      });
      Provider.of<ChatProvider>(context, listen: false).setUserId(id);
      return id;
    })
        .then((value) => Provider.of<ChatProvider>(context, listen: false)
            .getUserMessagesHistory(value))
        .then((_) => Provider.of<ChatProvider>(context, listen: false)
            .connectAndListen())
        .then((_) => setState(() {
              _isLoading = false;
            }));
  }

  DateTime? _selectedDateTime;
  final TextEditingController _titleController = TextEditingController();
  String? _location;

  void _handleDateTimeChange(DateTime? dateTime) {
    if (dateTime == null) return;
    setState(() {
      _selectedDateTime = dateTime;
    });
  }

  void _createAppointment() {
    if (_selectedDateTime != null &&
        _titleController.text.isNotEmpty &&
        _location != null) {
      print("Create appointment");
      Provider.of<ChatProvider>(context, listen: false).addAppointment(
          _titleController.text,
          _location!,
          _selectedDateTime!,
          "",
          "",
          "",
          "");
      Navigator.of(context).pop();
    } else {
      ErrorHelper.showError(message: "Vui lòng điển đủ thông tin lịch hẹn");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userName),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      height: 600,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.alarm),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Thêm lịch hẹn",
                                style: headingStyle,
                              ),
                            ],
                          ),
                          const Text(
                            "Đặt lịch hẹn với người này?",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          KFormField(
                            hintText: "Tiêu đề",
                            controller: _titleController,
                            onChanged: (p0) {
                              setState(() {
                                _titleController.text = p0;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DateTimePicker(
                            onDateTimeChanged: _handleDateTimeChange,
                            label: "Thêm ngày",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                            future: Provider.of<ChatProvider>(context,
                                    listen: false)
                                .getRecommendCafe(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Row(
                                  children: [
                                    CircularProgressIndicator.adaptive(),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text("Đang lấy địa điểm gợi ý...")
                                  ],
                                );
                              }
                              if (snapshot.hasError) {
                                return const Text("Error");
                              }
                              var locations =
                                  snapshot.data as List<RecommendCafeModel>;
                              return KSelectForm(
                                hintText: "Địa điểm",
                                onChanged: (p0) {
                                  if (p0 != null) {
                                    setState(() {
                                      _location = p0.value;
                                    });
                                  }
                                },
                                options: locations
                                    .map((e) => KeyValuePair(
                                        e.description, e.description))
                                    .toList(),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Hủy")),
                              TextButton(
                                  onPressed: () {
                                    _createAppointment();
                                  },
                                  child: const Text("Đặt lịch")),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.coffee))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: Consumer<ChatProvider>(
                      builder: (context, provider, child) {
                    var messages = provider.getUserMessages(provider.userId);
                    return ListView.builder(
                        itemCount: messages.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          var message = ChatMessageModel(
                            messageId: messages[index].messageId,
                            senderId: messages[index].senderId,
                            senderAvt: messages[index].senderAvt,
                            senderName: messages[index].senderName,
                            receiverId: messages[index].receiverId,
                            receiverAvt: messages[index].receiverAvt,
                            receiverName: messages[index].receiverName,
                            messageContent: messages[index].messageContent,
                            createdAt: messages[index].createdAt,
                            messageType: !(messages[index].receiverId ==
                                provider.userId),
                            appointment: messages[index].appointment,
                            isAppointment: messages[index].isAppointment,
                          );
                          bool canConfirm =
                              message.appointment?.isApproved == null &&
                                  message.isAppointment == true &&
                                  message.senderId == provider.userId;
                          bool canCancel = message.appointment != null &&
                              message.appointment!.isApproved != false;
                          var appointmentComponent = <Widget>[
                            Container(
                              height: 270,
                              padding: const EdgeInsets.all(16),
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
                                  const Icon(
                                    Icons.alarm,
                                    size: 48,
                                    color: kPrimaryColor,
                                  ),
                                  Text(
                                    "Lịch hẹn: ${message.appointment?.title}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    DateTimeHelper.formatDateTime(
                                        message.appointment?.dateTime ??
                                            DateTime.now()),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "Địa điểm: ${message.appointment?.location}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Visibility(
                                    visible:
                                        message.appointment?.isApproved == true,
                                    child: const Text("Đã xác nhận",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      canCancel
                                          ? TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: kErrorColor,
                                                  fixedSize:
                                                      const Size(100, 20)),
                                              onPressed: () async {
                                                await ChatService()
                                                    .changeStatusSchedule(
                                                        message
                                                            .appointment!.id!,
                                                        false);
                                                ErrorHelper.showError(
                                                    message:
                                                        "Hủy lịch hẹn thành công");
                                                setState(() {
                                                  message.appointment!
                                                      .isApproved = false;
                                                });
                                              },
                                              child: const Text(
                                                "Hủy",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : const Text("Đã hủy",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                      Visibility(
                                        visible: canConfirm,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                fixedSize: const Size(100, 20)),
                                            onPressed: () async {
                                              await ChatService()
                                                  .changeStatusSchedule(
                                                      message.appointment!.id!,
                                                      true);
                                              ErrorHelper.showError(
                                                  message:
                                                      "Xác nhận lịch hẹn thành công");
                                              setState(() {
                                                message.appointment!
                                                    .isApproved = true;
                                              });
                                            },
                                            child: const Text(
                                              "Xác nhận",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ];
                          var avt = message.senderAvt;
                          var chatComponent = <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(avt),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                                color: (message.messageType!
                                    ? Colors.grey.shade200
                                    : kPrimaryLightColor),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Text(message.messageContent),
                            ),
                          ];
                          if (!message.messageType!) {
                            chatComponent = chatComponent.reversed.toList();
                            avt = message.receiverAvt;
                          }
                          return Container(
                            padding: const EdgeInsets.all(10),
                            child: message.isAppointment
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: appointmentComponent,
                                  )
                                : Column(
                                    children: [
                                      Text(DateTimeHelper.formatDateTime3(
                                          message.createdAt)),
                                      Row(
                                        mainAxisAlignment: message.messageType!
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.end,
                                        children: chatComponent,
                                      ),
                                    ],
                                  ),
                          );
                        });
                  }),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            constraints: const BoxConstraints(
                              maxHeight: 50,
                              minHeight: 10,
                            ),
                            hintStyle: const TextStyle(fontSize: 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onChanged: (String messageText) {},
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          if (_controller.text.isNotEmpty) {
                            await Provider.of<ChatProvider>(context,
                                    listen: false)
                                .sendMessage(_controller.text);
                          }
                          _controller.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
