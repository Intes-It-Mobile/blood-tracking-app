import 'dart:ffi';

import 'package:blood_sugar_tracking/views/personal_data/components/edit_personal_data.dart';
import 'package:flutter/material.dart';

import '../../../widgets/goal_dialog/goal_mg_edit_dialog.dart';

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
            height: MediaQuery.of(context).size.height * 0.28,
             child: const EditPersonalData(),
          ),
        );
      },
    );
  }

  Future<void> DialogAge(BuildContext context) {
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
            height: MediaQuery.of(context).size.height * 0.38,
            child: const EditPersonalAge(),
          ),
        );
      },
    );
  }

  Future<void> DialogWeight(BuildContext context) {
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
            height: MediaQuery.of(context).size.height * 0.38,
            child: const EditPersonalWeight(),
          ),
        );
      },
    );
  }

  Future<void> DialogHeight(BuildContext context) {
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
            height: MediaQuery.of(context).size.height * 0.38,
            child: const EditPersonalHeight(),
          ),
        );
      },
    );
  }
  Future<void> showDialogGoalMg(BuildContext context) {
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
            height: MediaQuery.of(context).size.height * 0.38,
            child: const EditGoalMg(),
          ),
        );
      },
    );
  }
  Future<void> showDialogGoalMol(BuildContext context) {
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
            height: MediaQuery.of(context).size.height * 0.38,
            child: const EditGoalMg(),
          ),
        );
      },
    );
  }
}
