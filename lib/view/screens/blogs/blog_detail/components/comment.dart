import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Comment extends StatefulWidget {
  final String avtUrl;
  final String name;
  final String content;
  final bool isLiked;
  final int numberOfLikes;
  final String time;
  const Comment({
    super.key,
    required this.avtUrl,
    required this.name,
    required this.content,
    required this.isLiked,
    required this.numberOfLikes,
    required this.time,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  late bool _isLiked;

  @override
  void initState() {
    _isLiked = widget.isLiked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(100.0)),
            child: Image.network(
              widget.avtUrl,
              height: 32,
              width: 32,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(widget.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ),
        Text(widget.content),
        Visibility(
          visible: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        _isLiked = !_isLiked;
                      });
                    },
                    child: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_outline,
                      color: Colors.red,
                    )),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "${widget.numberOfLikes}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(
                  width: 32,
                ),
                Text(
                  widget.time,
                  style: TextStyle(color: Colors.grey[600]),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
