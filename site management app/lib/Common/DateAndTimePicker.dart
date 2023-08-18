import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateAndTimePicker extends StatefulWidget{
  final void Function(String date) onDataSubmission;
  final String title;

  const DateAndTimePicker({super.key, required this.title,required this.onDataSubmission});

  @override
  State<DateAndTimePicker> createState() => DateAndTimePickerState();
}

class DateAndTimePickerState extends State<DateAndTimePicker>{

  String date = "YYYY-MM-DD";

  void _sendDataToParent(String date){
    widget.onDataSubmission(date);
  }

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.title, style: const TextStyle(fontSize: 20),),
        const SizedBox(height: 7.5,),
        TextButton(
        onPressed: () async {
          final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000, 8),
              lastDate: DateTime(2050, 8));
          if (picked != null && picked.toString() != date) {
            setState(() {
              date = picked.toString();
            });
          }
          _sendDataToParent(date.split(' ')[0]);
        },
        child: Text(date.split(' ')[0],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            backgroundColor: CupertinoColors.systemGrey5
          ),
        ),
      ),
      ],
    );
  }
}