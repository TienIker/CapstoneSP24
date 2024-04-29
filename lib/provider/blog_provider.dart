import 'package:flutter/material.dart';
import 'package:sharing_cafe/helper/shared_prefs_helper.dart';
import 'package:sharing_cafe/model/blog_model.dart';
import 'package:sharing_cafe/service/blog_service.dart';

class BlogProvider extends ChangeNotifier {
  // private
  List<BlogModel> _blogs = [];
  BlogModel? _blogDetails;
  List<BlogModel> _myBlogs = [];

  // public
  List<BlogModel> get blogs => _blogs;
  BlogModel get blogDetails => _blogDetails!;
  List<BlogModel> get myBlogs => _myBlogs;

  Future getBlogs() async {
    _blogs = await BlogService().getBlogs();
    notifyListeners();
  }

  Future setLike() async {
    final userId = await SharedPrefHelper.getUserId();
    bool isSuccess = false;
    if (_blogDetails!.isLike) {
      isSuccess = await BlogService()
          .unlikeBlog(userId: userId, blogId: _blogDetails!.blogId);
    } else {
      isSuccess = await BlogService()
          .likeBlog(userId: userId, blogId: _blogDetails!.blogId);
    }
    if (isSuccess) {
      _blogDetails!.isLike = !_blogDetails!.isLike;
      if (_blogDetails!.isLike) {
        _blogDetails!.likesCount++;
      } else {
        _blogDetails!.likesCount--;
      }
      notifyListeners();
    }
  }

  Future getBlogDetails(String blogId) async {
    _blogDetails = await BlogService().getBlogDetails(blogId);
    notifyListeners();
  }

  Future getMyBlogs() async {
    _myBlogs = await BlogService().getMyBlogs();
    notifyListeners();
  }
}
