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
  XFile? xFile;

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
      if (value != PermissionStatus.denied) {
        await initCamera();
      }
    });
  }

  Future<void> checkHeartBeat() async {
    int level = Random().nextInt(2);
    bool isTakingPicture = false; // Biến để theo dõi xem camera có đang chụp ảnh hay không

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      time++;
      if (time == 45) {
        timer.cancel();
        if (cameraController.value.isRecordingVideo) {
          await cameraController.stopVideoRecording();
        }
        cameraIsInitialize = false;
        await cameraController.setFlashMode(FlashMode.off);
        int re = bmp;
        setState(() {
          checkTap = 0;
          time = 0;
          bmp = 0;
        });

        // Di chuyển điều hướng đến bên ngoài callback của setState
        Navigator.of(context).pushNamed(
          Routes.new_record_heart_rate,
          arguments: HeartRateInfo(date: DateTime.now(), indicator: re),
        );
        return;
      } else {
        setState(() {
          switch (level) {
            case 0:
              bmp = Random().nextInt(60) + 1;
              break;
            case 1:
              bmp = 60 + Random().nextInt(40);
              break;
            default:
              bmp = 100 + Random().nextInt(20);
          }
        });

        if (!cameraController.value.isRecordingVideo && !isTakingPicture) {
          isTakingPicture = true;
          await cameraController.startVideoRecording();
          XFile xFile = await cameraController.takePicture();
          List<Color> colors = analyzeImageColors(xFile.path);
          print("Colors: ${colors}");
          isTakingPicture = false;
        }
      }
    });
  }

  List<Color> analyzeImageColors(String imagePath) {
    List<Color> colors = [];

    img.Image? image = img.decodeImage(File(imagePath).readAsBytesSync());

    img.Image resizedImage = img.copyResize(image!, width: 100);

    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        img.Pixel pixel = resizedImage.getPixel(x, y);
        print("Pixel: $pixel");
        //(156,12,12)
        int red = img.uint32ToRed(pixel.);
        int green = img.uint32ToGreen(pixel[0].toInt());
        int blue = img.uint32ToBlue(pixel[0].toInt());

        colors.add(Color.fromARGB(255, red, green, blue));
      }
    }

    return colors;
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
      toolbarHeight: 56,
      backgroundColor: AppColors.AppColor2,
      title: Text(
        AppLocalizations.of(context).getTranslate("heart_rate_tracking"),
        style: AppTheme.appBarTextStyle,
      ),
      actions: [
        _buildButtonHeartRateHistory()
      ],
    );
  }

  Widget _buildButtonHeartRateHistory() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.history_heart_rate);
      },
      child: Container(
        height: 32,
        width: 32,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: SvgPicture.asset(Assets.iconHearRate),
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
              AppLocalizations.of(context).getTranslate("put_your_finger_on_camera"),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.greyColor, fontFamily: FontFamily.IBMPlexSans, fontSize: 14, fontWeight: FontWeight.w600),
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
      margin: const EdgeInsets.only(bottom: 16),
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
            child: (checkTap == 0)
                ? Image.asset(
                    Assets.image_heart,
                    height: 91,
                    width: 91,
                    fit: BoxFit.contain,
                  )
                : (checkTap == 1 || checkTap == 2)
                    ? _buildRunHeartRate()
                    : Container(),
            onTap: () {
              setState(() async {
                if (checkTap == 0) {
                  checkTap = 1;
                  getData();
                  requestPermission();
                } else if (checkTap == 1) {
                  null;
                }
              });
            },
          ),
          Container(
            width: 110,
            margin: const EdgeInsets.only(top: 8),
            child: _buildTextStatus(),
          )
        ],
      ),
    );
  }

  Widget _buildRunHeartRate() {
    TextStyle textStyle = TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700, fontFamily: FontFamily.IBMPlexSans);
    return Container(
      width: 111,
      height: 101,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Center(
            child: LiquidCustomProgressIndicator(
              value: time / 45,
              valueColor: const AlwaysStoppedAnimation(Colors.pink),
              backgroundColor: Colors.blue,
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
                      TextSpan(text: ' BPM', style: textStyle.copyWith(fontSize: 16)),
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
        style: TextStyle(color: AppColors.AppColor4, fontFamily: FontFamily.IBMPlexSans, fontSize: 12, fontWeight: FontWeight.w600),
      );
    }
    if (checkTap == 1) {
      return Text(
        AppLocalizations.of(context).getTranslate("measuring"),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: AppColors.AppColor4, fontFamily: FontFamily.IBMPlexSans, fontSize: 12, fontWeight: FontWeight.w600),
      );
    }
    return Text(
      AppLocalizations.of(context).getTranslate("result"),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: AppColors.AppColor4, fontFamily: FontFamily.IBMPlexSans, fontSize: 12, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildButtonNewRecord() {
    return InkWell(
      onTap: () {
        setState(() {
          checkTap = 0;
          time = 0;
          bmp = 0;
        });
        Navigator.of(context).pushNamed(
          Routes.new_record_heart_rate,
          arguments: HeartRateInfo(date: DateTime.now(), indicator: 70),
        );
      },
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        margin: const EdgeInsets.only(top: 24),
        decoration: BoxDecoration(color: AppColors.AppColor4, borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context).getTranslate("new_record"),
              style: TextStyle(color: Colors.white, fontFamily: FontFamily.IBMPlexSans, fontStyle: FontStyle.normal, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.8),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(Assets.iconEditBtn)
          ],
        ),
      ),
    );
  }
}
