import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/model/blog_model.dart';
import 'package:sharing_cafe/service/blog_service.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_detail/blog_detail_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_list/components/blog_card.dart';

class BlogCategoryScreen extends StatefulWidget {
  static String routeName = "blog-category";
  const BlogCategoryScreen({super.key});

  @override
  State<BlogCategoryScreen> createState() => _BlogCategoryScreenState();
}

class _BlogCategoryScreenState extends State<BlogCategoryScreen> {
  String popular = "Phổ biến";
  String newest = "Mới nhất";
  String sortType = "Phổ biến";
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final interestImageUrl = arguments["imageUrl"];
    final interestTitle = arguments["title"];
    final interestNumber = arguments["number"];
    final interestId = arguments["interestId"];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          interestTitle,
          style: heading2Style,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 128,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(interestImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              interestTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text("$interestNumber blogs",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sắp xếp theo",
                    style: heading2Style,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        sortType == newest
                            ? sortType = popular
                            : sortType = newest;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          sortType,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          Icons.sort,
                          color: kPrimaryColor,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: BlogService().getBlogsbyInterestId(interestId),
                builder: (context, snapshot) {
                  List<BlogModel> blogs = snapshot.data == null
                      ? []
                      : snapshot.data as List<BlogModel>;
                  return ListView.builder(
                    itemCount: blogs.length,
                    itemBuilder: (context, index) {
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
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
