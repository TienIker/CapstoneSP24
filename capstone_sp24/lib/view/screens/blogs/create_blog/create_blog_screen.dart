import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';
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
  // You will need to manage the state for the inputs and selections
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tạo bài viết',
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
              onPressed: () {
                // Handle attend action
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => kPrimaryColor),
                padding: MaterialStateProperty.resolveWith(
                    (states) => const EdgeInsets.symmetric(horizontal: 16.0)),
              ),
              child: const Text(
                'Đăng',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // Open image picker
              },
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                    color: kFormFieldColor,
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                alignment: Alignment.center,
                child: Column(
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
            const KFormField(
              hintText: "Tên sự kiện",
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Blog', style: heading2Style),
            ),
            const BlogEditor(),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Chọn chủ đề', style: heading2Style),
            ),
            const KSelectForm(
              hintText: 'Chọn chủ đề',
              options: [],
            )
          ],
        ),
      ),
    );
  }
}
