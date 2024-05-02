import 'package:flutter/material.dart';
import 'package:sharing_cafe/model/event_model.dart';
import 'package:sharing_cafe/service/event_service.dart';
import 'package:sharing_cafe/model/blog_model.dart';
import 'package:sharing_cafe/service/blog_service.dart';

class HomeProvider extends ChangeNotifier {
  // private variables
  List<EventModel> _suggestEvents = [];
  List<BlogModel> _blogs = [];

  // public
  List<EventModel> get suggestEvents => _suggestEvents;
  List<BlogModel> get blogs => _blogs;

  Future getSuggestEvents() async {
    _suggestEvents = await EventService().getSuggestEvents();
    notifyListeners();
  }

  Future getBlogs() async {
    _blogs = await BlogService().getPopularBlogs();
    notifyListeners();
  }
}
