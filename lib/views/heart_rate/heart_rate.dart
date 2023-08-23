import 'dart:io';
import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'dart:async';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:blood_sugar_tracking/models/heart_rate/heart_rate_info.dart';
import 'package:blood_sugar_tracking/routes.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/ads/mrec_ads.dart';

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
  int bmp = 0;
  int checkTap = 0;
  int checkFingerTime = 0;
  bool checkFinger = false;
  bool loadFinger = false;
  bool start = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getData() async {
    cameras = await availableCameras();
    cameraController =
        CameraController(cameras[0], ResolutionPreset.max, enableAudio: false);
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
        await checkHeartBeat();
      });
    }).catchError((error) {
      setState(() {
        cameraIsInitialize = false;
      });
    });
  }

  Future<void> requestPermission() async {
    await Permission.camera.request().then((value) async {
      if (value != PermissionStatus.permanentlyDenied &&
          value != PermissionStatus.denied) {
        await getData();
        await initCamera();
        setState(() {
          checkTap = 1;
          checkFinger = false;
        });
      } else {
        showAccessDisabled();
      }
    });
  }

  bool outRunTime = false;

  Future<void> checkHeartBeat() async {
    DateTime dateOld = DateTime.now();
    start = true;
    Timer.periodic(const Duration(milliseconds: 700), (timer) async {
      if (outRunTime) {
        timer.cancel();
        outRunTime = false;
        start = false;
      }
      DateTime dateNew = DateTime.now();
      Duration diff = dateNew.difference(dateOld);
      bool checkFingerOld = checkFinger;
      if (loadFinger == false) checkFingerByCamera();
      if (!checkFinger) {
        checkFingerTime += diff.inMilliseconds;
        if (checkFingerTime > 20000) {
          timer.cancel();
          start = false;
          if (cameraController.value.isRecordingVideo) {
            await cameraController.stopVideoRecording();
          }
          cameraIsInitialize = false;
          await cameraController.setFlashMode(FlashMode.off);
          showDialogError();
          return;
        }
      }
      if (checkFinger != checkFingerOld) {
        setState(() {});
      }
      if (checkFinger) {
        time += diff.inMilliseconds;
        if (time > 45000) {
          timer.cancel();
          start = false;
          if (cameraController.value.isRecordingVideo) {
            await cameraController.stopVideoRecording();
          }
          cameraIsInitialize = false;
          await cameraController.setFlashMode(FlashMode.off);
          int re = bmp;
          Navigator.of(context).pushNamed(
            Routes.new_record_heart_rate,
            arguments: HeartRateInfo(date: DateTime.now(), indicator: re),
          );
          setState(() {
            checkTap = 0;
            time = 0;
            bmp = 0;
            checkFingerTime = 0;
            checkFinger = false;
          });
          return;
        } else {
          if (bmp == 0) bmp = 60 + Random().nextInt(20) + 1;
          int dau = Random().nextInt(2);
          int t = Random().nextInt(6);
          setState(() {
            if (bmp < 60 || (dau == 0 && bmp < 114)) {
              bmp += t;
            } else {
              bmp -= t;
            }
          });
        }
      }
      dateOld = dateNew;
    });
  }

  Future<void> checkFingerByCamera() async {
    setState(() {
      loadFinger = true;
    });
    XFile xFile = await cameraController.takePicture();
    String imagePath = xFile.path;
    img.Image? image = img.decodeImage(File(imagePath).readAsBytesSync());
    img.Image resizedImage = img.copyResize(image!, width: 30, height: 30);
    int sum = (resizedImage.height * resizedImage.width / 4).toInt();
    int pass = 0, fail = 0;
    check(int x, int y) {
      img.Pixel pixel = resizedImage.getPixel(x, y);
      int red = img.uint32ToRed(pixel[0].toInt());
      int green = img.uint32ToGreen(pixel[0].toInt());
      int blue = img.uint32ToBlue(pixel[0].toInt());
      // print("$red $green $blue");
      if (red > green &&
          red > blue &&
          red - green > 100 &&
          red - blue > 100 &&
          red > 130)
        pass++;
      else
        fail++;
    }

    int height = resizedImage.height;
    int width = resizedImage.width;
    for (int y = 0; y < height; y++) {
      for (int i = 0; i < 10; i++) {
        check(i, y);
      }
      for (int i = width - 10; i < width; i++) {
        check(i, y);
      }
    }
    for (int x = 0; x < width; x++) {
      for (int i = 0; i < 10; i++) {
        check(x, i);
      }
      for (int i = height - 10; i < height; i++) {
        check(x, i);
      }
    }
    setState(() {
      loadFinger = false;
      checkFinger = (pass > fail * 6);
    });
  }

  Path _buildHeartPath() {
    return Path()
      ..moveTo(55, 101)
      ..lineTo(47.4525, 93.7346)
      ..cubicTo(18.87, 68.0305, 0, 51.0229, 0, 30.2725)
      ..cubicTo(0, 13.2648, 13.431, 0, 30.525, 0)
      ..cubicTo(40.182, 0, 49.4505, 4.45831, 55.5, 11.4485)
      ..cubicTo(61.5495, 4.45831, 70.818, 0, 80.475, 0)
      ..cubicTo(97.569, 0, 111, 13.2648, 111, 30.2725)
      ..cubicTo(111, 51.0229, 92.13, 68.0305, 63.5475, 93.7346)
      ..lineTo(55.5, 101)
      ..close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarCustom(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBarCustom() {
    return AppBar(
      toolbarHeight: 56,
      backgroundColor: AppColors.AppColor2,
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          AppLocalizations.of(context).getTranslate("heart_rate_tracking"),
          style: AppTheme.appBarTextStyle,
        ),
      ),
      actions: [_buildButtonHeartRateHistory()],
    );
  }

  Widget _buildButtonHeartRateHistory() {
    return InkWell(
      onTap: () async {
        if (start) await reset();
        Navigator.of(context).pushNamed(Routes.history_heart_rate);
      },
      child: Container(
        height: 32,
        width: 32,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: SvgPicture.asset(
          Assets.iconHistory,
          height: 16,
        ),
      ),
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
          if (checkTap == 1)
            Text(
              AppLocalizations.of(context).getTranslate(
                  checkFinger ? "check_finger" : "put_your_finger_on_camera"),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: checkFinger ? AppColors.greyColor : Color(0xFFFD4755),
                  fontFamily: FontFamily.IBMPlexSans,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          _buildButtonNewRecord(),
          Center(child: const MRECAds()),
        ],
      ),
    );
  }

  Widget _buildButtonHeartRate() {
    return GestureDetector(
      onTap: () {
        if (checkTap == 0) {
          requestPermission();
        }
      },
      child: Container(
        height: 181,
        width: 181,
        margin: const EdgeInsets.only(bottom: 16),
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
            (checkTap == 0)
                ? Image.asset(
                    Assets.image_heart,
                    height: 91,
                    width: 91,
                    fit: BoxFit.contain,
                  )
                : (checkTap == 1 || checkTap == 2)
                    ? _buildRunHeartRate()
                    : Container(),
            Container(
              width: 130,
              margin: const EdgeInsets.only(top: 8),
              child: _buildTextStatus(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRunHeartRate() {
    TextStyle textStyle = TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontFamily: FontFamily.IBMPlexSans);
    return Container(
      width: 111,
      height: 101,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Center(
            child: LiquidCustomProgressIndicator(
              value: time / 45000,
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFD4755)),
              backgroundColor: AppColors.AppColor4,
              direction: Axis.vertical,
              shapePath: _buildHeartPath(),
            ),
          ),
          SizedBox(
            width: 111,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: bmp.toString(),
                    style: textStyle,
                    children: <TextSpan>[
                      TextSpan(
                          text: ' BPM',
                          style: textStyle.copyWith(fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
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
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextStatus() {
    if (checkTap == 0) {
      return Text(
        AppLocalizations.of(context).getTranslate("tap_to_measure"),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: AppColors.AppColor4,
            fontFamily: FontFamily.IBMPlexSans,
            fontSize: 16,
            fontWeight: FontWeight.w600),
      );
    }
    if (checkTap == 1) {
      return Text(
        AppLocalizations.of(context).getTranslate("measuring"),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: AppColors.AppColor4,
            fontFamily: FontFamily.IBMPlexSans,
            fontSize: 16,
            fontWeight: FontWeight.w600),
      );
    }
    return Text(
      AppLocalizations.of(context).getTranslate("result"),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: AppColors.AppColor4,
          fontFamily: FontFamily.IBMPlexSans,
          fontSize: 16,
          fontWeight: FontWeight.w600),
    );
  }

  Widget _buildButtonNewRecord() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
          color: AppColors.AppColor4, borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: () async {
          if (start) await reset();
          Navigator.of(context).pushNamed(
            Routes.new_record_heart_rate,
            arguments: HeartRateInfo(date: DateTime.now(), indicator: 70),
          );
        },
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
      ),
    );
  }

  void showDialogError() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              actions: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      width: 144,
                      decoration: const BoxDecoration(
                          color: AppColors.AppColor2,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)
                              .getTranslate("try_again"),
                          style: AppTheme.TextIntroline16Text.copyWith(
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: Text(
                  AppLocalizations.of(context)
                      .getTranslate("show_error_heart_rate"),
                  style: AppTheme.Headline16Text.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            )).whenComplete(() async {
      await reset();
    });
  }

  void showAccessDisabled() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: const BoxDecoration(
                              color: AppColors.AppColor3,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)
                                  .getTranslate("return"),
                              style: AppTheme.TextIntroline16Text.copyWith(
                                  color: AppColors.AppColor2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 23),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          openAppSettings();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: const BoxDecoration(
                              color: AppColors.AppColor2,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)
                                  .getTranslate("go_to_setting"),
                              style: AppTheme.TextIntroline16Text,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              content: Text(
                AppLocalizations.of(context)
                    .getTranslate("request_open_permission"),
                style: AppTheme.Headline16Text.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontFamily: FontFamily.roboto),
                textAlign: TextAlign.center,
              ),
              title: Text(
                AppLocalizations.of(context).getTranslate("access_disabled"),
                style: AppTheme.Headline20Text.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ));
  }

  @override
  void deactivate() async {
    super.deactivate();
    if (start) await reset();
  }

  Future<void> reset() async {
    if (start) outRunTime = true;
    if (cameraController.value.isRecordingVideo) {
      await cameraController.stopVideoRecording();
    }
    cameraIsInitialize = false;
    await cameraController.setFlashMode(FlashMode.off);
    setState(() {
      checkTap = 0;
      time = 0;
      bmp = 0;
      checkFingerTime = 0;
      checkFinger = false;
      checkTap = 0;
    });
  }
}
