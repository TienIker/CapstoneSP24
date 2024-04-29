import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/helper/shared_prefs_helper.dart';
import 'package:sharing_cafe/model/comment_model.dart';
import 'package:sharing_cafe/provider/blog_provider.dart';
import 'package:sharing_cafe/service/blog_service.dart';
import 'package:sharing_cafe/view/components/form_field.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_detail/components/comment.dart';

class BlogDetailScreen extends StatefulWidget {
  static String routeName = "/blog-detail";
  const BlogDetailScreen({super.key});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  bool _isLoading = false;

  final TextEditingController _contentEditingController =
      TextEditingController();

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero, () {
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      var id = arguments['id'];
      return id;
    })
        .then((value) => Provider.of<BlogProvider>(context, listen: false)
            .getBlogDetails(value))
        .then((_) => setState(() {
              _isLoading = false;
            }));

    super.initState();
  }

  String howOldFrom(DateTime createdAt) {
    var diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) {
      return "${diff.inDays} ngày trước";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} giờ trước";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} phút trước";
    } else {
      return "vài giây trước";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Consumer<BlogProvider>(
              builder: (context, value, child) {
                var blog = value.blogDetails;
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      expandedHeight: 300.0,
                      floating: false,
                      pinned: true,
                      snap: false,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        background: ClipRRect(
                          child: Image.network(
                            blog.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      iconTheme: const IconThemeData(color: Colors.white),
                      actions: [
                        IconButton(
                            onPressed: () {
                              showMenu(
                                  context: context,
                                  position: const RelativeRect.fromLTRB(
                                      100, 50, 0, 0),
                                  items: [
                                    PopupMenuItem(
                                      onTap: () {
                                        final TextEditingController
                                            reportContentController =
                                            TextEditingController();
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("Báo cáo"),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                        "Bạn có chắc chắn muốn báo cáo bài viết này?"),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    //text field for report content
                                                    KFormField(
                                                      hintText:
                                                          "Nội dung báo cáo",
                                                      maxLines: 3,
                                                      controller:
                                                          reportContentController,
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Hủy"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (reportContentController
                                                          .text.isEmpty) {
                                                        ErrorHelper.showError(
                                                            message:
                                                                "Vui lòng nhập nội dung báo cáo");
                                                        return;
                                                      }
                                                      var loggedUser =
                                                          await SharedPrefHelper
                                                              .getUserId();
                                                      var res = await BlogService()
                                                          .reportBlog(
                                                              reporterId:
                                                                  loggedUser,
                                                              blogId:
                                                                  blog.blogId,
                                                              content:
                                                                  reportContentController
                                                                      .text);
                                                      if (res) {
                                                        // ignore: use_build_context_synchronously
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child:
                                                        const Text("Báo cáo"),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: const Text("Báo cáo"),
                                    ),
                                  ]);
                            },
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ))
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        blog.title,
                                        textAlign: TextAlign.left,
                                        style: headingStyle,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              value.setLike();
                                            },
                                            child: Icon(
                                              blog.isLike
                                                  ? Icons.favorite
                                                  : Icons.favorite_outline,
                                              color: Colors.red,
                                            )),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "${blog.likesCount}",
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100.0)),
                                        child: Image.network(
                                          blog.ownerAvatar ??
                                              "https://picsum.photos/id/233/200/300",
                                          height: 64.0,
                                          width: 64.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16.0,
                                      ),
                                      Expanded(
                                        child: Text(
                                          blog.ownerName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: kPrimaryColor,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8.0))),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Text(
                                          blog.category,
                                          style: const TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        howOldFrom(blog.createdAt),
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Html(data: blog.content),
                                FutureBuilder(
                                    future:
                                        BlogService().loadComment(blog.blogId),
                                    builder: (context, snapshot) {
                                      var comments = snapshot.data == null
                                          ? []
                                          : snapshot.data as List<CommentModel>;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Bình luận (${comments.length})",
                                            style: headingStyle,
                                          ),
                                          ListView.builder(
                                              itemCount: comments.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Comment(
                                                    avtUrl: comments[index]
                                                        .profileAvatar,
                                                    name: comments[index]
                                                        .userName,
                                                    content:
                                                        comments[index].content,
                                                    isLiked: false,
                                                    numberOfLikes: 0,
                                                    time: "");
                                              })
                                        ],
                                      );
                                    }),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    // ClipRRect(
                                    //   borderRadius: const BorderRadius.all(
                                    //       Radius.circular(100.0)),
                                    //   child: Image.network(
                                    //     blog.ownerAvatar ??
                                    //         "https://picsum.photos/id/233/200/300",
                                    //     height: 48,
                                    //     width: 48,
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    // ),
                                    // const SizedBox(
                                    //   width: 16,
                                    // ),
                                    Expanded(
                                        child: KFormField(
                                      hintText: "Viết bình luận...",
                                      controller: _contentEditingController,
                                    )),
                                    IconButton(
                                        onPressed: () async {
                                          if (_contentEditingController
                                              .text.isNotEmpty) {
                                            await BlogService().createComment(
                                                blogId: blog.blogId,
                                                content:
                                                    _contentEditingController
                                                        .text);
                                            setState(() {
                                              _contentEditingController.clear();
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.send,
                                          color: kPrimaryColor,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
