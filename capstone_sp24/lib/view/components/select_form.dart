import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/key_value_pair.dart';

class KSelectForm extends StatefulWidget {
  final String hintText;
  final List<KeyValuePair<String, String>> options;
  final Function(KeyValuePair<String, String>?)? onChanged;
  final KeyValuePair<String, String>? selectedValue;
  const KSelectForm({
    super.key,
    required this.hintText,
    required this.options,
    this.onChanged,
    this.selectedValue,
  });

  @override
  State<KSelectForm> createState() => _KSelectFormState();
}

class _KSelectFormState extends State<KSelectForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: kFormFieldColor),
      child: DropdownButtonFormField<KeyValuePair<String, String>>(
        value: widget.selectedValue,
        icon: const Icon(Icons.arrow_drop_down),
        hint: Text(widget.hintText),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          isDense: true,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: widget.onChanged,
        items: widget.options
            .map<DropdownMenuItem<KeyValuePair<String, String>>>(
                (KeyValuePair<String, String> value) {
          return DropdownMenuItem<KeyValuePair<String, String>>(
            value: value,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 90,
              child: Text(
                value.value,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
