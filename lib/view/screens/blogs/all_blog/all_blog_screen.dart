import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_list/components/blog_card.dart';
import 'package:sharing_cafe/view/screens/events/event_detail/event_detail_screen.dart';

class AllBlogScreen extends StatefulWidget {
  static String routeName = "/all-blog";
  const AllBlogScreen({super.key});

  @override
  State<AllBlogScreen> createState() => _AllBlogScreenState();
}

class _AllBlogScreenState extends State<AllBlogScreen> {
  String newest = "Mới nhất";
  String oldest = "Cũ nhất";
  String sortType = "Mới nhất";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Blogs",
          style: heading2Style,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                            ? sortType = oldest
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
              child: ListView(
                children: <Widget>[
                  BlogCard(
                    imageUrl: 'https://picsum.photos/id/123/200/300',
                    title:
                        'Hội thảo nghệ thuật "Sell Yourself" - Hành trình Khởi lửa hành trang',
                    dateTime: 'T2, 20 THÁNG 5 LÚC 18.00',
                    avtUrl: 'https://picsum.photos/id/43/200/300',
                    ownerName: 'Bùi Hoàng Việt Anh',
                    time: '5 phút trước',
                    onTap: () {
                      Navigator.pushNamed(context, EventDetailScreen.routeName);
                    },
                  ),
                  BlogCard(
                    imageUrl: 'https://picsum.photos/id/765/200/300',
                    title: 'Lễ hội âm nhạc Infinity Street Festival 2024',
                    dateTime: 'T2, 20 THÁNG 5 LÚC 18.00',
                    avtUrl: 'https://picsum.photos/id/215/200/300',
                    ownerName: 'Phạm Hải Yến',
                    time: '8 phút trước',
                    onTap: () {
                      Navigator.pushNamed(context, EventDetailScreen.routeName);
                    },
                  ),
                  BlogCard(
                    imageUrl: 'https://picsum.photos/id/233/200/300',
                    title:
                        'M\'aRTISaN Workshop: Workshop vẽ tranh Canvas - THE WORLD AT YOUR FINGERTIPS',
                    dateTime: 'T2, 20 THÁNG 5 LÚC 18.00',
                    avtUrl: 'https://picsum.photos/id/23/200/300',
                    ownerName: 'Khuất Văn Khang',
                    time: '12 phút trước',
                    onTap: () {
                      Navigator.pushNamed(context, EventDetailScreen.routeName);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
