import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/datetime_helper.dart';
import 'package:sharing_cafe/provider/blog_provider.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_detail/blog_detail_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_list/components/blog_card.dart';

class SearchBlogScreen extends StatefulWidget {
  static String routeName = "/search-blog";
  const SearchBlogScreen({super.key});

  @override
  State<SearchBlogScreen> createState() => _SearchBlogScreenState();
}

class _SearchBlogScreenState extends State<SearchBlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BlogProvider>(builder: (context, blogProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
              color: kFormFieldColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Tìm kiếm',
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
              onSubmitted: (value) async {
                await blogProvider.search(value);
                blogProvider.insertSearchHistry(value);
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: blogProvider.searchBlogs.isNotEmpty
              ? ListView.builder(
                  itemCount: blogProvider.searchBlogs.length,
                  itemBuilder: (context, index) {
                    return BlogCard(
                      imageUrl: blogProvider.searchBlogs[index].image,
                      title: blogProvider.searchBlogs[index].title,
                      dateTime: DateTimeHelper.formatDateTime2(
                          blogProvider.searchBlogs[index].createdAt),
                      avtUrl: blogProvider.searchBlogs[index].ownerAvatar ??
                          blogProvider.searchBlogs[index].image,
                      ownerName: blogProvider.searchBlogs[index].ownerName,
                      time: DateTimeHelper.howOldFrom(
                          blogProvider.searchBlogs[index].createdAt),
                      onTap: () {
                        Navigator.pushNamed(context, BlogDetailScreen.routeName,
                            arguments: {
                              'id': blogProvider.searchBlogs[index].blogId,
                            });
                      },
                    );
                  },
                )
              : Column(
                  children: <Widget>[
                    Visibility(
                      visible: blogProvider.searchHistory.isNotEmpty,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Tìm kiếm trước đó',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () =>
                              blogProvider.removeAllSearchHistory(),
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: blogProvider.searchHistory.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              blogProvider.searchHistory[index],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey[600]),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () =>
                                  blogProvider.removeFromSearchHistory(
                                      blogProvider.searchHistory[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
