import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/provider/blog_provider.dart';
import 'package:sharing_cafe/provider/interest_provider.dart';
import 'package:sharing_cafe/view/screens/blogs/all_blog/all_blog_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_categories.dart/blog_categories_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_category.dart/blog_category_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_detail/blog_detail_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_list/components/blog_card_2.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_list/components/blog_card_3.dart';
import 'package:sharing_cafe/view/screens/blogs/create_blog/create_blog_screen.dart';
import 'package:sharing_cafe/view/screens/events/search/search_screen.dart';

import 'components/blog_card.dart';

class BlogListScreen extends StatefulWidget {
  static String routeName = "/blogs";
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<BlogProvider>(context, listen: false)
        .getBlogs()
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
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/cafe.png',
              height: 20,
            ),
            const SizedBox(
              width: 8,
            ),
            Text('Blog', style: heading2Style.copyWith(color: kPrimaryColor)),
          ],
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
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Consumer<BlogProvider>(builder: (context, value, child) {
              var blogs = value.blogs;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Phổ biến",
                        style: heading2Style,
                      ),
                    ),
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: blogs.length,
                        itemBuilder: (context, index) {
                          var blog = blogs[index];
                          return BlogCard2(
                            imageUrl: blog.image,
                            title: blog.title,
                            dateTime:
                                DateTimeHelper.formatDateTime(blog.createdAt),
                            avtUrl: blog.ownerAvatar ??
                                'https://picsum.photos/id/200/200/300',
                            ownerName: blog.ownerName,
                            time: howOldFrom(blog.createdAt),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, BlogDetailScreen.routeName,
                                  arguments: {
                                    'id': blog.blogId,
                                  });
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Khám phá theo chủ đề",
                            style: heading2Style,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, BlogCategoriesScreen.routeName);
                            },
                            child: const Text(
                              "Xem tất cả",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 128,
                      child: Consumer<InterestProvider>(
                        builder: (context, value, child) {
                          var interests = value.listInterestsParent;
                          if (interests.isEmpty) {
                            value.getListInterestsParent();
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }
                          return ListView.builder(
                            itemCount: interests.length,
                            itemBuilder: (context, index) {
                              return BlogCard3(
                                imageUrl: interests[index].imageUrl,
                                title: interests[index].name,
                                number: interests[index].numOfBlog,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, BlogCategoryScreen.routeName,
                                      arguments: {
                                        "interestId":
                                            interests[index].interestId,
                                        "imageUrl": interests[index].imageUrl,
                                        "title": interests[index].name,
                                        "number": interests[index].numOfBlog,
                                      });
                                },
                              );
                            },
                            scrollDirection: Axis.horizontal,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Blogs mới",
                            style: heading2Style,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AllBlogScreen.routeName);
                            },
                            child: const Text(
                              "Xem tất cả",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor),
                            ),
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: blogs.length,
                      itemBuilder: (context, index) {
                        var blog = blogs[index];
                        return BlogCard(
                          imageUrl: blog.image,
                          title: blog.title,
                          dateTime:
                              DateTimeHelper.formatDateTime(blog.createdAt),
                          avtUrl: blog.ownerAvatar ??
                              'https://picsum.photos/id/200/200/300',
                          ownerName: blog.ownerName,
                          time: howOldFrom(blog.createdAt),
                          onTap: () {
                            Navigator.pushNamed(
                                context, BlogDetailScreen.routeName,
                                arguments: {
                                  'id': blog.blogId,
                                });
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
    );
  }
}
