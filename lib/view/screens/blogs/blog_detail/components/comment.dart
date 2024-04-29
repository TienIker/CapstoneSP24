// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sharing_cafe/helper/shared_prefs_helper.dart';
import 'package:sharing_cafe/service/blog_service.dart';
import 'package:sharing_cafe/view/components/custom_network_image.dart';
import 'package:sharing_cafe/view/components/form_field.dart';

class Comment extends StatefulWidget {
  final String id;
  final String avtUrl;
  final String userId;
  final String name;
  final String content;
  final bool isLiked;
  final int numberOfLikes;
  final String time;
  final Function()? onEditComment;
  const Comment(
      {super.key,
      required this.id,
      required this.avtUrl,
      required this.name,
      required this.userId,
      required this.content,
      required this.isLiked,
      required this.numberOfLikes,
      required this.time,
      this.onEditComment});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  late bool _isLiked;
  bool _editing = false;
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    _isLiked = widget.isLiked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey moreButtonKey = GlobalKey();
    _contentController.text = widget.content;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(100.0)),
            child: CustomNetworkImage(
              url: widget.avtUrl,
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
            key: moreButtonKey,
            onPressed: () async {
              //show menu
              // Get the RenderBox object
              final RenderBox renderBox =
                  moreButtonKey.currentContext?.findRenderObject() as RenderBox;
              final Offset offset = renderBox.localToGlobal(Offset.zero);

              // Calculate the position for the menu
              final RelativeRect position = RelativeRect.fromLTRB(
                  offset.dx, // This is the left position.
                  offset.dy, // This is the top position.
                  30, // This is the right position (not used here).
                  0 // This is the bottom position (not used here).
                  );
              var loggedId = await SharedPrefHelper.getUserId();
              var canDelete = widget.userId == loggedId;
              var canEdit = widget.userId == loggedId;
              // Show the menu
              if (canEdit && canDelete) {
                showMenu(
                  context: context,
                  position: position,
                  items: [
                    if (canEdit)
                      PopupMenuItem(
                        value: "edit",
                        onTap: () {
                          setState(() {
                            _editing = true;
                          });
                        },
                        child: const Text("Chỉnh sửa"),
                      ),
                    if (canDelete)
                      PopupMenuItem(
                        value: "delete",
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Xác nhận"),
                                content: const Text(
                                    "Bạn có chắc chắn muốn xóa bình luận này không?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Hủy"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      BlogService()
                                          .deleteComment(commentId: widget.id)
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: const Text("Xóa"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Xóa",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                );
              }
            },
          ),
        ),
        _editing
            ? Row(
                children: [
                  Expanded(
                    child: KFormField(
                      hintText: "Nhập nội dung bình luận",
                      value: widget.content,
                      controller: _contentController,
                    ),
                  ),
                  // submit
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      BlogService()
                          .updateComment(
                              commentId: widget.id,
                              content: _contentController.text)
                          .then((value) {
                        widget.onEditComment!();
                        setState(() {
                          _editing = false;
                        });
                      });
                    },
                  )
                ],
              )
            : Text(widget.content),
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
