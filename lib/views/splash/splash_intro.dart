// ignore_for_file: prefer_const_constructors

import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/routes.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/locale/appLocalizations.dart';
import '../../widgets/share_local.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentIndex = 0;
  int indexPage = 0;

  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.58,
            child: PageView.builder(
                itemCount: intro.length,
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                    indexPage = index;
                  });
                },
                itemBuilder: (_, index) {
                  return buildPage(
                    intro[index]["img"],
                    intro[index]["text"],
                  );
                }),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 48, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 28),
                  alignment: Alignment.bottomRight,
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: SlideEffect(
                        radius: 2,
                        paintStyle: PaintingStyle.stroke,
                        strokeWidth: 1,
                        activeDotColor: AppColors.AppColor4,
                        dotColor: AppColors.AppColor4,
                        dotHeight: 8,
                        dotWidth: 18),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    indexPage == 3
                        ? Container()
                        : GestureDetector(
                      onTap: () {
                        shareLocal.putBools("isFirst", true);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.home,
                              (route) => false,
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 36,
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: AppColors.AppColor2,
                          ),
                        ),
                        child: Text(
                          "${AppLocalizations.of(context)!.getTranslate('skip_all')}",
                          textAlign: TextAlign.center,
                          style: AppTheme.TextIntroline16Text.copyWith(color: AppColors.AppColor2),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (indexPage == 3) {
                          shareLocal.putBools("isFirst", true);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.home,
                                (route) => false,
                          );
                        }
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceIn,
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 36,
                        margin: EdgeInsets.only(left: 17),
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                        decoration: BoxDecoration(
                          gradient:
                          LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                            AppColors.AppColor4,
                            AppColors.AppColor2,
                          ]),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          indexPage == 3
                              ? "${AppLocalizations.of(context)!.getTranslate('homepage')}"
                              : "${AppLocalizations.of(context)!.getTranslate('next_step')}",
                          textAlign: TextAlign.center,
                          style: AppTheme.TextIntroline16Text.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildPage(String image, String textIntro) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill)),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              indexPage == 4
                  ? Image.asset(
                    image,
                  )
                  : SizedBox(),

            ],
          ),
          Container(
              padding: EdgeInsets.only(left: 8),
              margin: EdgeInsets.only(bottom: 50),
              alignment: Alignment.bottomLeft,
              child: Text(
                "${AppLocalizations.of(context)!.getTranslate(textIntro)}",
                style: AppTheme.TextIntroline16Text,
              )),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> intro = [
    {
      "img": Assets.intro1,
      "text": "intro1",
    },
    {
      "img": Assets.intro2,
      "text": "intro2",
    },
    {
      "img": Assets.intro3,
      "text": "intro3",
    },
    {
      "img": Assets.intro4,
      "text": "intro4",
    },
  ];
}
