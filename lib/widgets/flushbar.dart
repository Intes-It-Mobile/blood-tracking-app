import 'package:another_flushbar/flushbar.dart';
import 'package:blood_sugar_tracking/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class FlushbarManager {
  static final FlushbarManager _singleton = FlushbarManager._internal();

  factory FlushbarManager() {
    return _singleton;
  }

  FlushbarManager._internal();
  String formatDateTime(DateTime dateTime) {
    String value;
    value = DateFormat('HH:mm dd/MM/yyyy').format(dateTime);
    return value;
  }

  void showFlushbar(BuildContext context, DateTime datetime) {
    Flushbar(
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Màu của bóng và độ trong suốt
          // spreadRadius: 5, // Độ lan rộng của bóng
          blurRadius: 10, // Độ mờ của bóng
          offset: Offset(0, 1), // Độ dịch chuyển của bóng
        ),
      ],
      borderRadius: BorderRadius.circular(10),
      margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      messageText: SnackBarWidget(dateTime: formatDateTime(datetime)),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
