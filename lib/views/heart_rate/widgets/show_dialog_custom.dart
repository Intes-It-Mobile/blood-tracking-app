import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:flutter/material.dart';

class ShowDialogCustom {
  Future<void> showDialogCustom({
    required BuildContext context,
    required String title,
    required String contentLeft,  
    required String contentRight,
    required Function() onClickBtnLeft,
    required Function() onClickBtnRight,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        elevation: 0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: Text(
                  title,
                  style: AppTheme.Headline16Text.copyWith(fontWeight: FontWeight.w500, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onClickBtnLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: const BoxDecoration(
                            color: AppColors.AppColor3, borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Center(
                          child: Text(
                            contentLeft,
                            style: AppTheme.TextIntroline16Text.copyWith(color: AppColors.AppColor2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 23),
                  Expanded(
                    child: GestureDetector(
                      onTap: onClickBtnRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: const BoxDecoration(
                            color: AppColors.AppColor2, borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Center(
                          child: Text(
                            contentRight,
                            style: AppTheme.TextIntroline16Text,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}