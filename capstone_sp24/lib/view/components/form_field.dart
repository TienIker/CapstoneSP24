import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';

class KFormField extends StatelessWidget {
  final String? hintText;
  final int? maxLines;
  final Function(String)? onChanged;
  const KFormField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kFormFieldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
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
