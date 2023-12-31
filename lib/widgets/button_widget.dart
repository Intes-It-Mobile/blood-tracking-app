import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_theme.dart';
import '../constants/assets.dart';
import '../utils/locale/appLocalizations.dart';

class ButtonWidget extends StatefulWidget {
  Color? btnColor = Colors.white;
  String? btnText = "";
  String? suffixIconPath;
  bool? mainAxisSizeMin = false;
  bool? enable=false;
  VoidCallback? onTap;
  EdgeInsetsGeometry? margin = EdgeInsetsDirectional.only(top: 20);
  ButtonWidget(
      {super.key,
      this.btnColor,
      this.onTap,
      this.btnText,
      this.suffixIconPath,
      this.mainAxisSizeMin,
      this.margin,this.enable});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: widget.enable!=null? (widget.enable==true? widget.onTap:(){}):widget.onTap,
      child: Container(
        margin: widget.margin != null
            ? widget.margin
            : EdgeInsetsDirectional.only(top: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            color: widget.enable!=null?(widget.enable==true? widget.btnColor:Colors.grey):widget.btnColor),
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: widget.mainAxisSizeMin == true
              ? MainAxisSize.min
              : MainAxisSize.max,
          children: [
            widget.btnText != null
                ? Text(
                    "${AppLocalizations.of(context)!.getTranslate('${widget.btnText}')}",
                    style: AppTheme.BtnText.copyWith(fontWeight: FontWeight.w700))
                : SizedBox(),
            widget.suffixIconPath != null
                ? Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(Assets.iconEditBtn)
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
