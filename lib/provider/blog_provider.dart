import 'package:flutter/material.dart';
import 'package:sharing_cafe/model/blog_model.dart';
import 'package:sharing_cafe/service/blog_service.dart';

class BlogProvider extends ChangeNotifier {
  // private
  List<BlogModel> _blogs = [];
  BlogModel? _blogDetails;

  // public
  List<BlogModel> get blogs => _blogs;
  BlogModel get blogDetails => _blogDetails!;

  Future getBlogs() async {
    _blogs = await BlogService().getBlogs();
    notifyListeners();
  }

  Future getBlogDetails(String blogId) async {
    _blogDetails = await BlogService().getBlogDetails(blogId);
    notifyListeners();
  }
}
