import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/colors.dart';

class SucessDialog extends StatelessWidget {
  const SucessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(

          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          content: StatefulBuilder(builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.17,
              width: MediaQuery.of(context).size.width,
            );
          }),
        ),
        Center(
          child: Container(
              width: 320,
              height: 320,
              child: Lottie.asset('assets/json/success_icon.json')),
        )
      ],
    );
  }
}