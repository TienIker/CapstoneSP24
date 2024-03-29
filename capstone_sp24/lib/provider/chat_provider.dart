import 'package:flutter/material.dart';
import 'package:sharing_cafe/model/chat_message_model.dart';
import 'package:sharing_cafe/service/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final Map<String, List<ChatMessageModel>> _mapUserMessages = {};

  Future getUserMessagesHistory(String userId) async {
    var history = await ChatService().getHistory(userId);
    if (_mapUserMessages.containsKey(userId)) {
      _mapUserMessages[userId] = history;
    } else {
      _mapUserMessages.putIfAbsent(userId, () => history);
    }
    notifyListeners();
  }

  List<ChatMessageModel> getUserMessages(String userId) {
    var userMessages = _mapUserMessages[userId] ?? [];
    return userMessages.reversed.toList();
  }

  void addMessage(ChatMessageModel chatMessageModel) {
    if (_mapUserMessages.containsKey(chatMessageModel.senderId)) {
      _mapUserMessages[chatMessageModel.senderId]!.add(chatMessageModel);
    }
    if (_mapUserMessages.containsKey(chatMessageModel.receiverId)) {
      _mapUserMessages[chatMessageModel.receiverId]!.add(chatMessageModel);
    }
    notifyListeners();
  }

  void addAppointment(
      String title,
      String location,
      DateTime dateTime,
      String senderId,
      String receiverId,
      String senderAvt,
      String senderName,
      String receiverName,
      String receiverAvt) {
    var appointment = ChatMessageModel(
      messageId: "",
      senderId: senderId,
      receiverId: receiverId,
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
      ),
      isAppointment: true,
    );
    addMessage(appointment);
  }
}
