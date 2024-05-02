import 'package:flutter/material.dart';
import 'package:sharing_cafe/helper/shared_prefs_helper.dart';
import 'package:sharing_cafe/model/blog_model.dart';
import 'package:sharing_cafe/service/blog_service.dart';

class BlogProvider extends ChangeNotifier {
  // private
  List<BlogModel> _blogs = [];
  List<BlogModel> _popularBlogs = [];
  List<BlogModel> _newBlogs = [];
  BlogModel? _blogDetails;
  List<BlogModel> _myBlogs = [];
  final List<String> _searchHistory = [];
  List<BlogModel> _searchBlogs = [];

  // public
  List<BlogModel> get blogs => _blogs;
  List<BlogModel> get popularBlogs => _popularBlogs;
  List<BlogModel> get newBlogs => _newBlogs;
  BlogModel get blogDetails => _blogDetails!;
  List<BlogModel> get myBlogs => _myBlogs;
  List<String> get searchHistory => _searchHistory;
  List<BlogModel> get searchBlogs => _searchBlogs;

  Future getBlogs() async {
    _blogs = await BlogService().getBlogs();
    notifyListeners();
  }

  Future getPopularBlogs() async {
    _popularBlogs = await BlogService().getPopularBlogs();
    notifyListeners();
  }

  Future getNewBlogs() async {
    _newBlogs = await BlogService().getNewBlogs();
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

  void removeFromSearchHistory(String query) {
    _searchHistory.remove(query);
    notifyListeners();
  }

  void removeAllSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  Future search(String searchString) async {
    if (searchString == "") {
      _searchBlogs.clear();
      notifyListeners();
      return;
    }
    _searchBlogs = await BlogService().search(searchString);
    notifyListeners();
  }

  disposeSearchEvents() {
    _searchBlogs.clear();
    notifyListeners();
  }

  void insertSearchHistry(String value) {
    if (value.isNotEmpty) {
      _searchHistory.add(value);
      notifyListeners();
    }
  }

  // delete blog
  Future deleteBlog(String blogId) async {
    await BlogService().deleteBlog(blogId);
    _myBlogs.removeWhere((element) => element.blogId == blogId);
    notifyListeners();
  }
}
