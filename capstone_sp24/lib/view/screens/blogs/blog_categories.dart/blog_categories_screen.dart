import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';
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
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisExtent: 128),
          children: [
            BlogCard3(
              imageUrl: 'https://picsum.photos/id/23/200/300',
              title: 'Du lịch',
              number: 323,
              onTap: () {},
            ),
            BlogCard3(
              imageUrl: 'https://picsum.photos/id/43/200/300',
              title: 'Sức khỏe',
              number: 123,
              onTap: () {},
            ),
            BlogCard3(
              imageUrl: 'https://picsum.photos/id/54/200/300',
              title: 'Khoa học công nghệ',
              number: 323,
              onTap: () {},
            ),
            BlogCard3(
              imageUrl: 'https://picsum.photos/id/23/200/300',
              title: 'Du lịch',
              number: 323,
              onTap: () {},
            ),
            BlogCard3(
              imageUrl: 'https://picsum.photos/id/43/200/300',
              title: 'Sức khỏe',
              number: 323,
              onTap: () {},
            ),
            BlogCard3(
              imageUrl: 'https://picsum.photos/id/54/200/300',
              title: 'Đời sống',
              number: 323,
              onTap: () {},
            ),
            BlogCard3(
              imageUrl: 'https://picsum.photos/id/23/200/300',
              title: 'Du lịch',
              number: 323,
              onTap: () {},
            ),
            BlogCard3(
              imageUrl: 'https://picsum.photos/id/43/200/300',
              title: 'Sức khỏe',
              number: 323,
              onTap: () {},
            ),
            BlogCard3(
              imageUrl: 'https://picsum.photos/id/54/200/300',
              title: 'Đời sống',
              number: 323,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
