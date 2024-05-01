import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/provider/blog_provider.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_detail/blog_detail_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_list/components/blog_card.dart';
import 'package:sharing_cafe/view/screens/blogs/create_blog/create_blog_screen.dart';

class MyBlogScreen extends StatefulWidget {
  static String routeName = "/my-blog";
  const MyBlogScreen({super.key});

  @override
  State<MyBlogScreen> createState() => _MyBlogScreenState();
}

class _MyBlogScreenState extends State<MyBlogScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<BlogProvider>(context, listen: false)
        .getMyBlogs()
        .then((value) => setState(() {
              _isLoading = false;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bài viết của bạn",
          style: heading2Style,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_box_outlined,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, CreateBlogScreen.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Consumer<BlogProvider>(
                builder: (context, value, child) {
                  var blogs = value.myBlogs;
                  return ListView.builder(
                    itemCount: blogs.length,
                    itemBuilder: (context, index) {
                      GlobalKey moreButtonKey = GlobalKey();
                      return BlogCard(
                        imageUrl: blogs[index].image,
                        title: blogs[index].title,
                        dateTime: DateTimeHelper.formatDateTime2(
                            blogs[index].createdAt),
                        avtUrl: blogs[index].ownerAvatar ?? blogs[index].image,
                        ownerName: blogs[index].ownerName,
                        time: DateTimeHelper.howOldFrom(blogs[index].createdAt),
                        onTap: () {
                          Navigator.pushNamed(
                              context, BlogDetailScreen.routeName,
                              arguments: {
                                'id': blogs[index].blogId,
                              });
                        },
                        moreButtonKey: moreButtonKey,
                        onMoreButtonClick: () {
                          // Get the RenderBox object
                          final RenderBox renderBox =
                              moreButtonKey.currentContext?.findRenderObject()
                                  as RenderBox;
                          final Offset offset =
                              renderBox.localToGlobal(Offset.zero);

                          // Calculate the position for the menu
                          final RelativeRect position = RelativeRect.fromLTRB(
                              offset.dx, // This is the left position.
                              offset.dy, // This is the top position.
                              30, // This is the right position (not used here).
                              0 // This is the bottom position (not used here).
                              );

                          // Show the menu
                          showMenu(
                            context: context,
                            position: position,
                            items: [
                              PopupMenuItem(
                                value: "edit",
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, CreateBlogScreen.routeName,
                                      arguments: blogs[index].blogId);
                                },
                                child: const Text("Chỉnh sửa"),
                              ),
                              PopupMenuItem(
                                value: "delete",
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Xác nhận"),
                                        content: const Text(
                                            "Bạn có chắc chắn muốn xóa sự kiện này không?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Hủy"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Provider.of<BlogProvider>(context,
                                                      listen: false)
                                                  .deleteBlog(
                                                      blogs[index].blogId)
                                                  .then((value) {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: const Text("Xóa"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  "Xóa",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
