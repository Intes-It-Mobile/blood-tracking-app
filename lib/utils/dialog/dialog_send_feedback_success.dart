import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../locale/appLocalizations.dart';

class SendFeedbackSuccessDialog extends StatelessWidget {
  const SendFeedbackSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: Container(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  '${AppLocalizations.of(context)!.getTranslate('send_feedback_success')}',
                  style: AppTheme.Headline16Text.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 12, right: 15),
              decoration: BoxDecoration(
                  color: AppColors.AppColor2,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                    '${AppLocalizations.of(context)!.getTranslate('done')}',
                    style: AppTheme.Headline16Text),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
