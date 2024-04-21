import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/provider/interest_provider.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_category.dart/blog_category_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_list/components/blog_card_3.dart';

class BlogCategoriesScreen extends StatefulWidget {
  static String routeName = "/blog-categories";
  const BlogCategoriesScreen({super.key});

  @override
  State<BlogCategoriesScreen> createState() => _BlogCategoriesScreenState();
}

class _BlogCategoriesScreenState extends State<BlogCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Khám phá theo chủ đề",
          style: heading2Style,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<InterestProvider>(
          builder: (context, value, child) {
            if (value.listInterestsParent.isEmpty) {
              value.getListInterestsParent();
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 128),
              itemCount: value.listInterestsParent.length,
              itemBuilder: (context, index) {
                var interest = value.listInterestsParent[index];
                return BlogCard3(
                  imageUrl: interest.imageUrl,
                  title: interest.name,
                  number: interest.numOfBlog.toString(),
                  onTap: () {
                    Navigator.pushNamed(context, BlogCategoryScreen.routeName,
                        arguments: {
                          "interestId": interest.interestId,
                          "imageUrl": interest.imageUrl,
                          "title": interest.name,
                          "number": interest.numOfBlog,
                        });
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
