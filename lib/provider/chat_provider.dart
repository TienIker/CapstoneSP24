// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/helper/shared_prefs_helper.dart';
import 'package:sharing_cafe/model/chat_message_model.dart';
import 'package:sharing_cafe/model/schedule_model.dart';
import 'package:sharing_cafe/service/chat_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sharing_cafe/helper/api_helper.dart';

class ChatProvider extends ChangeNotifier {
  final Map<String, List<ChatMessageModel>> _mapUserMessages = {};
  late io.Socket socket;
  late String _userId;
  Widget _locationAutocompleteField = Container();
  final TextEditingController _locationController = TextEditingController();

  String get userId => _userId;
  Widget get locationAutocompleteField => _locationAutocompleteField;
  TextEditingController get locationController => _locationController;

  void connectAndListen() {
    socket = io.io(ApiHelper().socketBaseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.on('connect', (_) {
      print('connected');
    });

    socket.on('message', (data) {
      if (data == null) {
        ErrorHelper.showError(
            message: "Lỗi 500: Không kết nối được với socket");
        return;
      }
      //check data is json or not
      try {
        json.decode(data);
      } catch (e) {
        ErrorHelper.showError(message: data);
        return;
      }
      var message = ChatMessageModel.fromJson(data);
      message.messageType = message.receiverId == _userId;
      addMessage(message);
    });

    socket.connect();
  }

  Future sendMessage(String message) async {
    var loggedUserId = await SharedPrefHelper.getUserId();
    if (message.isNotEmpty) {
      var data = {
        'from': loggedUserId,
        'to': _userId,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      };
      socket.emit('message', data);
    }
  }

  void setUserId(String userId) {
    _userId = userId;
  }

  Future getUserMessagesHistory(String userId) async {
    var history = await ChatService().getHistory(userId);
    if (_mapUserMessages.containsKey(userId)) {
      _mapUserMessages[userId] = history;
    } else {
      _mapUserMessages.putIfAbsent(userId, () => history);
    }
    var schedules = await getSchedule();
    if (schedules.isNotEmpty) {
      // add all schedule to head of message list
      _mapUserMessages[userId]?.addAll(schedules
          .map((e) => ChatMessageModel(
              messageId: e.scheduleId,
              senderId: e.senderId,
              senderAvt: "",
              senderName: "",
              receiverId: e.receiverId,
              receiverAvt: "",
              receiverName: "",
              messageContent: e.content,
              createdAt: e.createdAt,
              messageType: false,
              appointment: Appointment(
                  id: e.scheduleId,
                  title: e.content,
                  location: e.location,
                  dateTime: e.date,
                  isApproved: e.isAccept),
              isAppointment: true))
          .toList());
    }
    _mapUserMessages[userId]
        ?.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    notifyListeners();
  }

  void removeSchedule(String appointmentId) {
    _mapUserMessages[_userId]?.removeWhere((element) =>
        element.isAppointment && element.appointment?.id == appointmentId);
    notifyListeners();
  }

  List<ChatMessageModel> getUserMessages(String userId) {
    var userMessages = _mapUserMessages[userId] ?? [];
    return userMessages.reversed.toList();
  }

  void addMessage(ChatMessageModel chatMessageModel) {
    if (_mapUserMessages.containsKey(chatMessageModel.senderId)) {
      if (!_mapUserMessages[chatMessageModel.senderId]!
          .any((element) => element.messageId == chatMessageModel.messageId)) {
        _mapUserMessages[chatMessageModel.senderId]!.add(chatMessageModel);
      }
    }
    if (_mapUserMessages.containsKey(chatMessageModel.receiverId)) {
      if (!_mapUserMessages[chatMessageModel.receiverId]!
          .any((element) => element.messageId == chatMessageModel.messageId)) {
        _mapUserMessages[chatMessageModel.receiverId]!.add(chatMessageModel);
      }
    }
    notifyListeners();
  }

  void addAppointment(
      String title,
      String location,
      DateTime dateTime,
      String senderAvt,
      String senderName,
      String receiverName,
      String receiverAvt) async {
    var senderId = await SharedPrefHelper.getUserId();
    var appointment = ChatMessageModel(
      messageId: "",
      senderId: senderId,
      receiverId: _userId,
      messageContent: "",
      createdAt: DateTime.now(),
      senderAvt: senderAvt,
      senderName: senderName,
      receiverName: receiverName,
      receiverAvt: receiverAvt,
      appointment: Appointment(
        title: title,
        location: location,
        dateTime: dateTime,
        isApproved: null,
      ),
      isAppointment: true,
    );

    var schedule = ScheduleModel(
        createdAt: DateTime.now(),
        scheduleId: "",
        content: title,
        location: location,
        date: dateTime,
        senderId: senderId,
        receiverId: _userId,
        isAccept: false);
    try {
      var res = await ChatService().createSchedule(schedule);
      appointment.appointment!.id = res.scheduleId;
      addMessage(appointment);
    } catch (e) {
      ErrorHelper.showError(message: "Không thể tạo lịch hẹn: 500");
    }
  }

  Future<List<String>> getRecommendCafe(String selectedKeyword) async {
    if (selectedKeyword.isEmpty) {
      selectedKeyword = "Highland Coffee";
    }
    var currentUserId = await SharedPrefHelper.getUserId();
    var recommendCafe = await ChatService()
        .getRecommendCafe(_userId, currentUserId, selectedKeyword);
    return recommendCafe.map((e) => e.description).toList();
  }

  Future<ScheduleModel> createSchedule(ScheduleModel scheduleModel) async {
    return ChatService().createSchedule(scheduleModel);
  }

  Future<List<ScheduleModel>> getSchedule() async {
    var listSchedule = await ChatService().getSchedule(_userId);
    if (listSchedule.isNotEmpty) {
      // listSchedule.removeWhere((element) => element.isAccept == false);
      listSchedule.sort((a, b) => a.date.compareTo(b.date));
      return listSchedule;
    }
    return [];
  }

  Future changeStatusSchedule(String scheduleId, bool isAccept) async {
    await ChatService().changeStatusSchedule(scheduleId, isAccept);
  }

  void setSelectedKeyword(String keyword) {
    _locationController.text = keyword;
    var focusNode = FocusNode();
    getLocationAutocomplteteField(_locationController, focusNode, callback);
    notifyListeners();
    focusNode.requestFocus();
  }

  callback(String suggestion) {
    var focusNode = FocusNode();
    _locationController.text = suggestion;
    getLocationAutocomplteteField(_locationController, focusNode, callback);
    notifyListeners();
    focusNode.requestFocus();
  }

  Future<Widget> getLocationAutocomplteteField(
      TextEditingController locationController,
      FocusNode focusNode,
      Function(String) callback) async {
    _locationAutocompleteField = TypeAheadField(
        controller: locationController,
        suggestionsCallback: (pattern) async {
          print(pattern);
          var text = pattern.isNotEmpty ? pattern : locationController.text;
          return await getRecommendCafe(text);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        focusNode: focusNode,
        onSelected: (suggestion) {
          callback(suggestion);
        },
        builder: (context, controller, focusNode) {
          return Container(
            decoration: BoxDecoration(
              color: kFormFieldColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                  hintText: "Nhập địa điểm",
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          );
        });
    notifyListeners();
    return _locationAutocompleteField;
  }
}
