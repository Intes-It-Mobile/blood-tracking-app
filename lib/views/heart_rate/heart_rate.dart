import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({super.key});

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    // Paint paint = Paint();
    // paint
    //   ..color = Colors.black
    //   ..style = PaintingStyle.stroke
    //   ..strokeCap = StrokeCap.round
    //   ..strokeWidth = 6;

    Paint paint1 = Paint();
    paint1
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    double width = size.width;
    double height = size.height;

    Path path = Path();
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.2 * width, height * 0.1, -0.25 * width, height * 0.6,
        0.5 * width, height);
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.8 * width, height * 0.1, 1.25 * width, height * 0.6,
        0.5 * width, height);

    canvas.drawPath(path, paint1);
    // canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarCustom(),
      body: _buildBody(),
    );
  }

  Path _buildHeartPath() {
    return Path()
      ..moveTo(55, 15)
      ..cubicTo(55, 20, 50, 0, 30, 0) //(1st curve)
      ..cubicTo(10, 0, 0, 10.5, 0, 37.5) // (2nd curve)
      ..cubicTo(0, 57.5, 20, 77, 55, 100) // (3rd curve)
      ..cubicTo(100, 77, 110, 57.5, 110, 37.5) // (4th curve)
      ..cubicTo(110, 10.5, 100, 0, 80, 0) // (5th curve)
      ..cubicTo(60, 0, 55, 20, 55, 15) // (6th curve)
      ..close();
  }

  AppBar _buildAppBarCustom() {
    return AppBar(
      backgroundColor: AppColors.AppColor2,
      title: Text(
        AppLocalizations.of(context).getTranslate("heart_rate_tracking"),
        style: TextStyle(
            fontFamily: FontFamily.IBMPlexSans,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 1),
      ),
      actions: [
        Container(
          height: 32,
          width: 32,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: SvgPicture.asset(Assets.iconHearRate),
        )
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButtonHeartRate(),
          const SizedBox(
            height: 30,
          ),
          _buildButtonNewRecord(),
        ],
      ),
    );
  }

  Container _buildButtonHeartRate() {
    return Container(
      height: 181,
      width: 181,
      // margin: const EdgeInsets.symmetric(vertical: 36),
      // padding: const EdgeInsets.only(top: 25, left: 35, right: 35, bottom: 35),
      decoration: BoxDecoration(
        color: AppColors.AppColor3,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(102, 136, 255, 0.70),
            blurRadius: 40,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image.asset(
          //   Assets.image_heart,
          //   height: 91,
          //   width: 91,
          //   fit: BoxFit.contain,
          // ),
          Stack(
            children: [
              Container(
                width: 125,
                height: 155,
                child: Center(
                  child: LiquidCustomProgressIndicator(
                    value: 0.2,
                    valueColor: const AlwaysStoppedAnimation(Colors.pink),
                    backgroundColor: Colors.blue,
                    // borderColor: Colors.transparent,
                    // borderWidth: 5.0,
                    // borderRadius: 12.0,
                    direction: Axis.vertical,
                    center: const Text("80BPM"),
                    shapePath: _buildHeartPath(),
                  ),
                ),
                // child: LiquidLinearProgressIndicator(
                //   value: 0.5,
                //   valueColor: const AlwaysStoppedAnimation(Colors.pink),
                //   backgroundColor: Colors.white,
                //   borderColor: Colors.red,
                //   borderWidth: 5.0,
                //   borderRadius: 12.0,
                //   direction: Axis.vertical,
                //   center: const Text("Loading..."),
                // ),
              ),
            ],
          ),
          // const Spacer(),
          SizedBox(
            width: 110,
            child: Text(
              AppLocalizations.of(context).getTranslate("tap_to_measure"),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColors.AppColor4,
                  fontFamily: FontFamily.IBMPlexSans,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Container _buildButtonNewRecord() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
          color: AppColors.AppColor4, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context).getTranslate("new_record"),
            style: TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.IBMPlexSans,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(Assets.iconEditBtn)
        ],
      ),
    );
  }
}
