// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/helper/shared_prefs_helper.dart';
import 'package:sharing_cafe/model/chat_message_model.dart';
import 'package:sharing_cafe/model/recommend_cafe.dart';
import 'package:sharing_cafe/model/schedule_model.dart';
import 'package:sharing_cafe/service/chat_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sharing_cafe/helper/api_helper.dart';

class ChatProvider extends ChangeNotifier {
  final Map<String, List<ChatMessageModel>> _mapUserMessages = {};
  late io.Socket socket;
  late String _userId;

  String get userId => _userId;

  void connectAndListen() {
    socket = io.io(ApiHelper().socketBaseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.on('connect', (_) {
      print('connected');
    });

    socket.on('message', (data) {
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

  Future<List<RecommendCafeModel>> getRecommendCafe() async {
    var currentUserId = await SharedPrefHelper.getUserId();
    var recommendCafe =
        await ChatService().getRecommendCafe(_userId, currentUserId);
    return recommendCafe;
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
}
