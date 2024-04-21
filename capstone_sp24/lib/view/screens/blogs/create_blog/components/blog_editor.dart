import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:sharing_cafe/constants.dart';

class BlogEditor extends StatefulWidget {
  final QuillController controller;
  const BlogEditor({
    super.key,
    required this.controller,
  });

  @override
  State<BlogEditor> createState() => _BlogEditorState();
}

class _BlogEditorState extends State<BlogEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: kFormFieldColor,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
            controller: widget.controller,
          )),
          Divider(
            color: Colors.grey[300],
          ),
          QuillEditor.basic(
            configurations: QuillEditorConfigurations(
              controller: widget.controller,
              placeholder: "Viết bài của bạn ở đây...",
              minHeight: 500,
            ),
          )
        ],
      ),
    );
  }
}
