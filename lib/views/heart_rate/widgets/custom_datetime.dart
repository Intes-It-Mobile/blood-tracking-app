import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

// class CustomDatetime extends StatefulWidget {
//   CustomDatetime({super.key, required this.date, required this.onChangedDate, required this.onChangedHour});
//   DateTime date;
//   final Function(DateTime) onChangedDate;
//   final Function() onChangedHour;
//   @override
//   State<CustomDatetime> createState() => _CustomDatetimeState();
// }

// class _CustomDatetimeState extends State<CustomDatetime> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
class CustomDatetime extends StatelessWidget {
  CustomDatetime({super.key, required this.date, required this.onChangedDate, required this.onChangedHour});
  final DateTime date;
  final Function(DateTime) onChangedDate;
  final Function(DateTime) onChangedHour;

  final TextStyle _textStyle = TextStyle(
    color: Colors.black,
    fontFamily: FontFamily.roboto,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8
  );
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Row(
      children: [
        InkWell(
          onTap: () {
            _showDatePickerDay();
          },
          child: _buildDateCustom()
        ),
        Spacer(),
        InkWell(
          onTap: () {
            _showDatePickerHour();
          },
          child: _buildTimeCustom(),
        )
      ],
    );
  }

  Container _buildDateCustom() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.AppColor3,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [ 
          customText(DateFormat('yyyy').format(date)),
          customText(DateFormat('MM').format(date)),
          customText(DateFormat('dd').format(date)),
        ],
      ),
    );
  }

  Container _buildTimeCustom() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.AppColor3,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          customText(DateFormat('HH').format(date)),
          Text(
            ":",
            style: _textStyle,
          ),
          customText(DateFormat('mm').format(date)),
        ],
      ),
    );
  }

  Widget customText(String content){
    return Container(
      height: 32,
      width: 60,
      alignment: Alignment.center,
      child: Text(
        content,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: _textStyle,
      ),
    );
  }


void _showDatePickerDay() {
    DatePicker.showDatePicker(
      maxDateTime: DateTime.now(),
      initialDateTime: date,
      dateFormat: "yyyy/MM/dd",
      context,
      onConfirm: (DateTime day, List<int> index) {
        onChangedDate(day);
      },
      locale: DateTimePickerLocale.en_us,
    );
  }

  void _showDatePickerHour() {
    DatePicker.showDatePicker(
      maxDateTime: DateTime.now(),
      initialDateTime: date,
      dateFormat: "HH:mm",
      context,
      onConfirm: (DateTime hour, List<int> index) {
        onChangedHour(hour);
      },
      locale: DateTimePickerLocale.en_us,
    );
  }
}