import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';

class KFormField extends StatelessWidget {
  final String? hintText;
  final int? maxLines;
  final String? value;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  const KFormField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    this.onChanged,
    this.value,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kFormFieldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.all(16),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none),
        onChanged: onChanged,
        maxLines: maxLines,
      ),
    );
  }
}
