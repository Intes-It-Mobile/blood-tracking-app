import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({super.key});

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool cameraIsInitialize = false;
  bool checkCamera = false;
  int time = 0;
  Timer? _timer;
  int bmp = 0;
  int checkTap = 0;

  @override
  void initState() {
    super.initState();
  }

  void getData() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    cameraController.setFlashMode(FlashMode.always);
    setState(() {
      checkCamera = true;
    });
  }

  Future<void> initCamera() async {
    await cameraController.initialize().then((value) {
      setState(() async {
        cameraIsInitialize = true;
        await cameraController.setFlashMode(FlashMode.torch);
        checkHeartBeat();
      });
    }).catchError((error) {
      setState(() {
        cameraIsInitialize = false;
      });
    });
  }

  Future<void> requestPermission() async {
    await Permission.camera.request().then((value) async {
      if (value != PermissionStatus.denied) {
        await initCamera();
      }
    });
  }

  // Future<void> _recognizeColors(CameraImage cameraImage) async {
  //   try {
  //     // final img.Image image = img.Image.fromBytes(
  //     //   width: cameraImage.width,
  //     //   format: img.Format.bgra,
  //     //   height: cameraImage.height,
  //     //   bytes: cameraImage.planes[0].bytesPerPixel,
  //     // );
  //     //
  //     // // Process the image to recognize colors
  //     // Color dominantColor = Colorize.computeDominantColor(image);
  //
  //     // TODO: Perform any actions with the recognized color (e.g., display it on the UI)
  //   } catch (e) {
  //     print("Error recognizing colors: $e");
  //   }
  // }

  Future<void> checkHeartBeat() async {
    int level = Random().nextInt(2);
    if (level == 0) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          time++;
        });
        if (time == 45) {
          setState(() async {
            _timer?.cancel();
            cameraIsInitialize = false;
            await cameraController.setFlashMode(FlashMode.off);
            checkTap = 2;
          });
        } else {
          setState(() {
            bmp = 40 + Random().nextInt(30) + 1;
          });
        }
      });
    } else if (level == 1) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          time++;
        });
        if (time == 45) {
          setState(() async {
            _timer?.cancel();
            cameraIsInitialize = false;
            await cameraController.setFlashMode(FlashMode.off);
            checkTap = 2;
          });
        } else {
          setState(() {
            bmp = 70 + Random().nextInt(50) + 1;
          });
        }
      });
    } else if (level == 2) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          time++;
        });
        if (time == 45) {
          setState(() async {
            _timer?.cancel();
            cameraIsInitialize = false;
            await cameraController.setFlashMode(FlashMode.off);
            checkTap = 2;
          });
        } else {
          setState(() {
            bmp = 120 + Random().nextInt(80) + 1;
          });
        }
      });
    }
  }

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
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: checkTap == 0
                ? Image.asset(
                    Assets.image_heart,
                    height: 91,
                    width: 91,
                    fit: BoxFit.contain,
                  )
                : checkTap == 1
                    ? Stack(
                        children: [
                          SizedBox(
                            width: 125,
                            height: 155,
                            child: Center(
                              child: LiquidCustomProgressIndicator(
                                value: time / 45,
                                valueColor:
                                    const AlwaysStoppedAnimation(Colors.pink),
                                backgroundColor: Colors.blue,
                                direction: Axis.vertical,
                                // center:  Text("${bmp.toString()}BPM"),
                                shapePath: _buildHeartPath(),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 45,
                            right: 45,
                            top: 50,
                            child: Container(
                              width: 30,
                              height: 30,
                              color: Colors.transparent,
                              child: checkCamera == false
                                  ? const CircularProgressIndicator()
                                  : CameraPreview(
                                      cameraController,
                                  ),
                            ),
                          ),
                          Positioned(
                            top: 85,
                            left: 30,
                            right: 30,
                            child: Text(
                              textAlign: TextAlign.center,
                              "${bmp.toString()} BPM",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        ],
                      )
                    : checkTap == 2
                        ? Image.asset(
                            Assets.image_heart,
                            height: 91,
                            width: 91,
                            fit: BoxFit.contain,
                          )
                        : Container(),
            onTap: () {
              setState(() async {
                if (checkTap != 1) {
                  checkTap = 1;
                  getData();
                  requestPermission();
                } else if (checkTap == 1) {
                  null;
                }
              });
            },
          ),
          // const Spacer(),
           SizedBox(
            width: 110,
            child: checkTap == 0 ? Text(
              AppLocalizations.of(context).getTranslate("tap_to_measure"),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColors.AppColor4,
                  fontFamily: FontFamily.IBMPlexSans,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ) : checkTap == 2 ? Text(
              "${bmp.toString()} BMP",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColors.AppColor4,
                  fontFamily: FontFamily.IBMPlexSans,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ) : null,
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
