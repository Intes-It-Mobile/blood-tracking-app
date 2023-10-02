import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_theme.dart';
import '../utils/locale/appLocalizations.dart';

class Loading {
  const Loading._();
  static Future<dynamic> show(BuildContext context,
      {Future<void> Function()? backButton}) {
    return showDialog(
        useSafeArea: false,
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: context!,
        builder: (context) {
          return const _LoadingWidget();
        });
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Lottie.asset('assets/json/loading_ad.json')),
          ),
          Text(
            "${AppLocalizations.of(context)!.getTranslate('loading_ads')}",
            style: AppTheme.loadingAdsText,
          )
        ],
      ),
    );
  }
}
