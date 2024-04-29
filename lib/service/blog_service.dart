// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:sharing_cafe/helper/api_helper.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/helper/shared_prefs_helper.dart';
import 'package:sharing_cafe/model/blog_model.dart';
import 'package:sharing_cafe/model/comment_model.dart';

class BlogService {
  Future<List<BlogModel>> getBlogs() async {
    try {
      var response = await ApiHelper().get('/blog');
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body) as List;
        return jsonList.map<BlogModel>((e) => BlogModel.fromJson(e)).toList();
      } else {
        ErrorHelper.showError(
            message:
                "Lỗi ${response.statusCode}: Không thể lấy danh sách blog");
      }
    } on Exception catch (_, e) {
      print(e);
    }
    return [];
  }

  // get my blog
  Future<List<BlogModel>> getMyBlogs() async {
    try {
      var response = await ApiHelper().get('/auth/user/my-blog');
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body) as List;
        return jsonList.map<BlogModel>((e) => BlogModel.fromJson(e)).toList();
      } else {
        ErrorHelper.showError(
            message:
                "Lỗi ${response.statusCode}: Không thể lấy danh sách blog của bạn");
      }
    } on Exception catch (_, e) {
      print(e);
    }
    return [];
  }

  Future<BlogModel?> getBlogDetails(String blogId) async {
    try {
      var userId = await SharedPrefHelper.getUserId();
      var response = await ApiHelper().get('/blog/$blogId?userId=$userId');
      if (response.statusCode == HttpStatus.ok) {
        return BlogModel.fromJson(json.decode(response.body)[0]);
      } else {
        ErrorHelper.showError(
            message: "Lỗi ${response.statusCode}: Không thể lấy blog");
      }
    } on Exception catch (_, e) {
      print(e);
    }
    return null;
  }

  Future<List<CommentModel>> loadComment(String blogId) async {
    try {
      var response = await ApiHelper().get('/blog/comment/$blogId');
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body) as List;
        return jsonList
            .map<CommentModel>((e) => CommentModel.fromJson(e))
            .toList();
      } else {
        ErrorHelper.showError(
            message:
                "Lỗi ${response.statusCode}: Không thể lấy danh sách bình luận");
      }
    } on Exception catch (_, e) {
      print(e);
    }
    return [];
  }

  Future createComment({
    required String blogId,
    required String content,
  }) async {
    var userId = await SharedPrefHelper.getUserId();
    var data = {"userId": userId, "blogId": blogId, "content": content};
    var response = await ApiHelper().post('/blog/comment', data);
    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể tạo bình luận");
    }
  }

  Future<List<BlogModel>> getBlogsbyInterestId(interestId) async {
    try {
      var response = await ApiHelper().get('/user/blogs/interest/$interestId');
      if (response.statusCode == HttpStatus.ok) {
        var jsonList = json.decode(response.body) as List;
        return jsonList.map<BlogModel>((e) => BlogModel.fromJson(e)).toList();
      } else {
        ErrorHelper.showError(
            message:
                "Lỗi ${response.statusCode}: Không thể lấy danh sách blog");
      }
    } on Exception catch (_, e) {
      print(e);
    }
    return [];
  }

  Future createBlog(
      {required String userId,
      required String interestId,
      required String content,
      required String title,
      required String image,
      required int likesCount,
      required int commentsCount,
      required bool isApprove}) async {
    var data = {
      "user_id": userId,
      "interest_id": interestId,
      "content": content.toString(),
      "title": title,
      "image": image,
      "likes_count": likesCount,
      "comments_count": commentsCount,
      "is_approve": isApprove
    };
    var response = await ApiHelper().post('/blog', data);
    if (response.statusCode == HttpStatus.ok) {
      Fluttertoast.showToast(msg: "Tạo blog thành công");
      return true;
    } else {
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể tạo blog");
    }
    return false;
  }

  Future reportBlog(
      {required String reporterId,
      required String blogId,
      required String content}) async {
    var data = {
      "reporter_id": reporterId,
      "blog_id": blogId,
      "content": content
    };
    var response = await ApiHelper().post('/user/blogs/report', data);
    if (response.statusCode == HttpStatus.ok) {
      Fluttertoast.showToast(msg: "Báo cáo blog thành công");
      return true;
    } else {
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể báo cáo blog");
    }
    return false;
  }

  // post /api/blogs/like
  Future likeBlog({required String userId, required String blogId}) async {
    var data = {"user_id": userId, "blog_id": blogId};
    var response = await ApiHelper().post('/blogs/like', data);
    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể thích blog");
    }
    return false;
  }

  // put /api/blogs/like
  Future unlikeBlog({required String userId, required String blogId}) async {
    var data = {"user_id": userId, "like_blog_id": blogId};
    var response = await ApiHelper().put('/blogs/like', data);
    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      ErrorHelper.showError(
          message: "Lỗi ${response.statusCode}: Không thể bỏ thích blog");
    }
    return false;
  }
}
