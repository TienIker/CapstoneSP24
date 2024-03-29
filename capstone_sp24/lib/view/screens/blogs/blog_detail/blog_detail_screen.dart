import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/provider/blog_provider.dart';
import 'package:sharing_cafe/view/components/form_field.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_detail/components/comment.dart';

class BlogDetailScreen extends StatefulWidget {
  static String routeName = "/blog-detail";
  const BlogDetailScreen({super.key});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  final String title = 'Top 5 điểm đến du lịch hàng đầu năm 2024!';

  final String avtUrl = 'https://picsum.photos/id/433/200/300';

  final String ownerName = 'Nguyễn Mai An';

  final String category = 'Du lịch';

  final String time = '3 ngày trước';

  final String content = """
            <div>
              <p>Năm 2024 sắp đến gần và cùng với đó là cơ hội để khám phá những địa điểm mới, thử những món ăn mới và gặp gỡ những người mới. Cho dù bạn là một du khách dày dạn kinh nghiệm hay một người mới, thì có rất nhiều điểm đến sẽ khiến trái tim bạn rung động. Dưới đây là 5 điểm đến du lịch hàng đầu cho năm 2024:</p>
              <h1>1. Hy Lạp</h1>
              <p>Từ những tàn tích cổ xưa của Athens đến những bãi biển tuyệt đẹp ở Santorini, Hy Lạp đều có thứ gì đó dành cho tất cả mọi người. Và với ngành khách sạn của đất nước đang trên đà phục hồi, bây giờ là thời điểm tuyệt vời để ghé thăm.</p>
            </div>
          """;

  final int numberOfComment = 250;

  bool _isLoading = false;

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
                            onPressed: () {},
                            icon: const Icon(
                              Icons.send_outlined,
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
                                Text(
                                  blog.title,
                                  textAlign: TextAlign.left,
                                  style: headingStyle,
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
                                          blog.image,
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
                                        time,
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Html(data: blog.content),
                                Text(
                                  "Bình luận (${blog.commentsCount})",
                                  style: headingStyle,
                                ),
                                const Comment(
                                    avtUrl:
                                        'https://picsum.photos/id/563/200/300',
                                    name: "Mai Anh Xuân",
                                    content:
                                        "Bài báo tuyệt vời! Tôi đã đến một vài điểm đến trong số này và rất nóng lòng được bổ sung thêm những điểm đến khác vào danh sách của mình ❤",
                                    isLiked: true,
                                    numberOfLikes: 354,
                                    time: "1 tháng trước"),
                                const Comment(
                                    avtUrl:
                                        'https://picsum.photos/id/321/200/300',
                                    name: "Đỗ Duy Nam",
                                    content:
                                        "Cảm ơn những lời khuyên và khuyến nghị! Tôi chắc chắn sẽ ghi nhớ những điều này cho chuyến đi tiếp theo của mình 🔥🔥",
                                    isLiked: false,
                                    numberOfLikes: 123,
                                    time: "2 tháng trước"),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100.0)),
                                      child: Image.network(
                                        blog.image,
                                        height: 48,
                                        width: 48,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    const Expanded(
                                        child: KFormField(
                                            hintText: "Viết bình luận...")),
                                    IconButton(
                                        onPressed: () {},
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
