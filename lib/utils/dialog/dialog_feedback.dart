import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../widgets/button_widget.dart';
import '../locale/appLocalizations.dart';
import 'dialog_send_feedback_success.dart';

class DialogFeedback extends StatefulWidget {
  const DialogFeedback({
    Key? key,
  }) : super(key: key);

  @override
  _DialogFeedbackState createState() => _DialogFeedbackState();
}

class _DialogFeedbackState extends State<DialogFeedback> {
  final formKey = GlobalKey<FormState>();
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AlertDialog(
        iconPadding: const EdgeInsets.only(right: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        alignment: Alignment.bottomCenter,
        insetPadding: const EdgeInsets.only(bottom: 0.0),
        titlePadding: const EdgeInsets.only(top: 10),
        contentPadding: EdgeInsets.zero,
        title: Stack(
          children: [
            Center(
              child: Text(
                "${AppLocalizations.of(context)!.getTranslate('feedback_title')}",
                style: AppTheme.Headline20Text.copyWith(
                    color: AppColors.AppColor4),
              ),
            ),
            Positioned(
              right: 0,
              top: -8,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    Assets.iconX,
                    color: AppColors.AppColor4,
                    height: 20,
                  ),
                ),
              ),
            )
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Container(
                  child: Text(
                    "${AppLocalizations.of(context)!.getTranslate('email_if_have')}",
                    style: AppTheme.appBodyTextStyle
                        .copyWith(color: AppColors.AppColor4),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.AppColor4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: TextFormField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText:
                        "${AppLocalizations.of(context)!.getTranslate('email_label_txt')}",
                    hintStyle: AppTheme.hintText,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 13),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Container(
                  child: Text(
                    "${AppLocalizations.of(context)!.getTranslate('feedback_write_dwn')}",
                    style: AppTheme.appBodyTextStyle
                        .copyWith(color: AppColors.AppColor4),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.AppColor4),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: TextFormField(
                  maxLines: 4,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      hintText:
                          "${AppLocalizations.of(context)!.getTranslate('feedback_write_dwn_label_txt')}",
                      hintStyle: AppTheme.hintText,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 20)),
                  onChanged: (value) {
                    if (value.length >= 6) {
                      setState(() {
                        isSelected = true;
                      });
                    } else {
                      setState(() {
                        isSelected = false;
                      });
                    }
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Center(
                  child: Text(
                    "${AppLocalizations.of(context)!.getTranslate('feedback_help')}",
                    style: AppTheme.appBodyTextStyle
                        .copyWith(color: AppColors.AppColor4),
                  ),
                ),
              ),
              Center(
                child: isSelected == false
                    ? Opacity(
                        opacity: 0.3,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.AppColor2,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          child: Text(
                            "${AppLocalizations.of(context)!.getTranslate('feedback_send_btn')}",
                            style: AppTheme.BtnText,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                          showDiaLog(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.AppColor2,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          child: Text(
                            "${AppLocalizations.of(context)!.getTranslate('feedback_send_btn')}",
                            style: AppTheme.BtnText,
                          ),
                        ),
                      ),
              )
            ]),
          ),
        ),
        actions: [],
      ),
    );
  }

  Future<String?> showDiaLog(
    BuildContext context,
  ) {
    return showDialog<String>(
      context: context,
      builder: (
        BuildContext context,
      ) =>
          SendFeedbackSuccessDialog(),
    );
  }
}
