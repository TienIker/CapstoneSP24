// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';

import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/model/chat_message_model.dart';
import 'package:sharing_cafe/provider/chat_provider.dart';
import 'package:sharing_cafe/service/chat_service.dart';
import 'package:sharing_cafe/view/components/date_time_picker.dart';
import 'package:sharing_cafe/view/components/form_field.dart';

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
  List<String> popularKeyword = [
    "Highlands Coffee",
    "Trung Nguyên Legend Café",
    "The Coffee House",
    "Phúc Long coffee & tea",
    "Cộng Cà Phê",
    "Milano Coffee"
  ];

  void _handleDateTimeChange(DateTime? dateTime) {
    if (dateTime == null) return;
    setState(() {
      _selectedDateTime = dateTime;
    });
  }

  void _createAppointment() {
    _location = Provider.of<ChatProvider>(context, listen: false)
        .locationController
        .text;
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
                Provider.of<ChatProvider>(context, listen: false)
                    .setSelectedKeyword("");
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      height: 1200,
                      width: double.infinity,
                      child: SingleChildScrollView(
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
                              firstDate:
                                  DateTime.now().add(const Duration(hours: 1)),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 30 * 6)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Địa điểm gợi ý",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            MultiSelectDropDown(
                              selectedOptionTextColor: kPrimaryColor,
                              hint: 'Chọn địa điểm gợi ý',
                              borderColor: Colors.transparent,
                              onOptionSelected: (options) async {
                                String selectedValue = options.isNotEmpty
                                    ? options.first.label.toString()
                                    : "";

                                Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .setSelectedKeyword(selectedValue);
                              },
                              onOptionRemoved: (index, option) {
                                Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .setSelectedKeyword("");
                              },
                              options: popularKeyword.map((e) {
                                return ValueItem(label: e, value: e);
                              }).toList(),
                              selectionType: SelectionType.single,
                              chipConfig: const ChipConfig(
                                  wrapType: WrapType.scroll,
                                  backgroundColor: kPrimaryColor),
                              // dropdownHeight: 400,
                              optionTextStyle: const TextStyle(fontSize: 16),
                              selectedOptionIcon:
                                  const Icon(Icons.check_circle),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Consumer<ChatProvider>(
                              builder: (context, value, child) {
                                return value.locationAutocompleteField;
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
                              height: 300,
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
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
                                    maxLines: 3,
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
