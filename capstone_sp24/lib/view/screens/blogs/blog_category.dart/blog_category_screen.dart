import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_list/components/blog_card.dart';
import 'package:sharing_cafe/view/screens/events/event_detail/event_detail_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Du lịch",
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
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://picsum.photos/id/456/400/400'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Du lịch',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text("323 blogs",
                                style: TextStyle(
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
              child: ListView(
                children: [
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
