import 'dart:ffi';

import 'package:blood_sugar_tracking/views/personal_data/components/edit_personal_data.dart';
import 'package:flutter/material.dart';

class Components {
  Components();

  Future<void> DialogGender(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 400,
            height: MediaQuery.of(context).size.height * 0.27,
             child: const EditPersonalData(),
          ),
        );
      },
    );
  }
}
