// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/error_helper.dart';

class DateTimePicker extends StatefulWidget {
  final Function(DateTime?) onDateTimeChanged;
  final String label;
  final DateTime? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  const DateTimePicker(
      {Key? key,
      required this.onDateTimeChanged,
      required this.label,
      this.value,
      this.firstDate,
      this.lastDate})
      : super(key: key);

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime? selectedDateTime;
  final DateFormat dateFormat = DateFormat('MMM d, yyyy h:mm a');

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: widget.firstDate ?? DateTime.now(),
      lastDate:
          widget.lastDate ?? DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
    );
    if (pickedTime == null) return;
    var isPast = pickedTime.hour < DateTime.now().hour ||
        (pickedTime.hour == DateTime.now().hour &&
            pickedTime.minute < DateTime.now().minute);
    if (isPast && pickedDate.isBefore(DateTime.now())) {
      ErrorHelper.showError(message: "Không thể chọn ngày quá khứ");
      return;
    }

    setState(() {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });

    widget.onDateTimeChanged(selectedDateTime);
  }

  @override
  void initState() {
    setState(() {
      selectedDateTime = widget.value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pickDateTime(context),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: kFormFieldColor),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
                if (selectedDateTime != null)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '${dateFormat.format(selectedDateTime!)} +07',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
              ],
            )),
      ),
    );
  }
}
