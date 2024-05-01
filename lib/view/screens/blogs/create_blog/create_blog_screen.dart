// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/helper/image_helper.dart';
import 'package:sharing_cafe/helper/key_value_pair.dart';
import 'package:sharing_cafe/helper/shared_prefs_helper.dart';
import 'package:sharing_cafe/model/blog_model.dart';
import 'package:sharing_cafe/provider/blog_provider.dart';
import 'package:sharing_cafe/provider/categories_provider.dart';
import 'package:sharing_cafe/service/blog_service.dart';
import 'package:sharing_cafe/service/image_service.dart';
import 'package:sharing_cafe/view/components/custom_network_image.dart';
import 'package:sharing_cafe/view/components/form_field.dart';
import 'package:sharing_cafe/view/components/select_form.dart';
import 'package:sharing_cafe/view/screens/blogs/create_blog/components/blog_editor.dart';

class CreateBlogScreen extends StatefulWidget {
  static String routeName = "/create-blog";
  const CreateBlogScreen({super.key});

  @override
  State<CreateBlogScreen> createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  String? _imageUrl;

  String? _interestId;
  final QuillController _contentController = QuillController.basic();

  final TextEditingController _titleController = TextEditingController();
  uploadImage(ImageSource source) async {
    var imageFile = await ImageHelper.pickImage(source);
    if (imageFile != null) {
      var url = await ImageService().uploadImage(imageFile);
      if (url.isNotEmpty) {
        setState(() {
          _imageUrl = url;
        });
      } else {
        ErrorHelper.showError(message: "Không tải được hình ảnh");
      }
    }
  }

  showImageTypeSelector() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.image_search),
              title: const Text('Chọn ảnh từ thư viện'),
              onTap: () {
                Navigator.pop(context);
                uploadImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Chụp ảnh mới'),
              onTap: () {
                Navigator.pop(context);
                uploadImage(ImageSource.camera);
              },
            ),
          ],
        ));
      },
    );
  }

  bool validateInput() {
    if (_interestId == null || _interestId!.isEmpty) {
      return false;
    }
    if (_contentController.document.toPlainText().isEmpty) {
      return false;
    }
    if (_titleController.text.isEmpty) {
      return false;
    }
    if (_imageUrl == null || _imageUrl!.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    String? blogId = ModalRoute.of(context)!.settings.arguments as String?;
    bool isEdit = blogId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Chỉnh sửa bài viết' : 'Tạo bài viết',
          style: heading2Style,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () async {
                if (!validateInput()) {
                  ErrorHelper.showError(
                      message: "Vui lòng nhập đầy đủ thông tin");
                  return;
                }
                var userId = await SharedPrefHelper.getUserId();
                var result = false;
                if (isEdit) {
                  result = await BlogService().updateBlog(
                      blogId: blogId,
                      userId: userId,
                      interestId: _interestId!,
                      content:
                          _contentController.document.toPlainText().toString(),
                      title: _titleController.text,
                      image: _imageUrl!);
                } else {
                  result = await BlogService().createBlog(
                      userId: userId,
                      interestId: _interestId!,
                      content:
                          _contentController.document.toPlainText().toString(),
                      title: _titleController.text,
                      image: _imageUrl!,
                      likesCount: 0,
                      commentsCount: 0,
                      isApprove: true);
                }
                if (result) {
                  Provider.of<BlogProvider>(context, listen: false)
                      .getMyBlogs();
                }
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => kPrimaryColor),
                padding: MaterialStateProperty.resolveWith(
                    (states) => const EdgeInsets.symmetric(horizontal: 16.0)),
              ),
              child: Text(
                isEdit ? 'Cập nhật' : 'Đăng',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future:
              isEdit ? BlogService().getBlogDetails(blogId) : Future.value(),
          builder: (context, snapshot) {
            if (isEdit && !snapshot.hasData) {
              return Container();
            }
            if (isEdit) {
              var blog = snapshot.data as BlogModel;
              if (blog.content != null) {
                _contentController.document = Document.fromHtml(blog.content!);
              }
              _titleController.text = blog.title;
              _imageUrl = blog.image;
              _interestId = blog.interestId;
            }
            return Form(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showImageTypeSelector();
                    },
                    child: Container(
                      height: 300,
                      decoration: const BoxDecoration(
                          color: kFormFieldColor,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      alignment: Alignment.center,
                      child: _imageUrl != null && _imageUrl!.isNotEmpty
                          ? CustomNetworkImage(
                              url: _imageUrl!,
                              fit: BoxFit.cover,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  color: Colors.grey[600],
                                  size: 48,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "Thêm ảnh bìa bài viết",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Tiêu đề', style: heading2Style),
                  ),
                  KFormField(
                    hintText: "Tên sự kiện",
                    controller: _titleController,
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Blog', style: heading2Style),
                  ),
                  BlogEditor(
                    controller: _contentController,
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Chọn chủ đề', style: heading2Style),
                  ),
                  Consumer<CategoriesProvider>(
                    builder: (context, categoriesProvider, child) {
                      if (categoriesProvider.categories.isEmpty) {
                        categoriesProvider.getCategories();
                      }

                      var interest = categoriesProvider.categories
                          .map((e) => KeyValuePair(e.categoryId, e.title))
                          .toList()
                          .firstWhereOrNull(
                              (element) => element.key == _interestId);
                      return KSelectForm(
                        hintText: 'Chọn chủ đề',
                        options: categoriesProvider.categories
                            .map((e) => KeyValuePair(e.categoryId, e.title))
                            .toList(),
                        onChanged: (p0) {
                          setState(() {
                            _interestId = p0?.key;
                          });
                        },
                        selectedValue: interest,
                      );
                    },
                  )
                ],
              ),
            );
          }),
    );
  }
}
