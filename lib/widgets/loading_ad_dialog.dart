import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
      child: Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Lottie.asset('assets/json/loading_ad.json')),
      ),
    );
  }
}
