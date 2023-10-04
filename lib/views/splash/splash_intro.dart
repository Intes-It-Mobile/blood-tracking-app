// ignore_for_file: prefer_const_constructors

import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/controllers/stores/sugar_info_store.dart';
import 'package:blood_sugar_tracking/routes.dart';
import 'package:blood_sugar_tracking/utils/ads/mrec_ads.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/config_ads_id.dart';
import '../../utils/ads_handle.dart';
import '../../utils/ads_helper.dart';
import '../../utils/ads_ios/ads.dart';
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
  SugarInfoStore? sugarInfoStore;
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
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.97,
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
                  child: Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.38,
                    right: 0,
                    left: 0,
                    child: Container(
                      // color: Colors.amber,
                      margin: EdgeInsets.only(bottom: 0, right: 16, left: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: indexPage != null
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${AppLocalizations.of(context)!.getTranslate("${getIntroText(indexPage)}")}",
                                        style: AppTheme.Intro20Text,
                                      ),
                                    )
                                  : Container()),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 28),
                                  alignment: Alignment.bottomRight,
                                  // color: AppColors.AppColor3,
                                  child: SmoothPageIndicator(
                                    controller: _pageController,
                                    count: 3,
                                    effect: SlideEffect(
                                        radius: 2,
                                        paintStyle: PaintingStyle.fill,
                                        strokeWidth: 1,
                                        activeDotColor: Color(0xFF00FFFF),
                                        dotColor: AppColors.AppColor3,
                                        dotHeight: 8,
                                        dotWidth: 18),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (indexPage == 2) {
                                          shareLocal.putBools("isFirst", true);
                                          if (sugarInfoStore!.isSwapedToMol ==
                                              true) {
                                            sugarInfoStore!
                                                .divisionListRootCondition();
                                            sugarInfoStore!.saveIsSwapedToMol(
                                                sugarInfoStore!.isSwapedToMol!);
                                          }
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Routes.home,
                                            (route) => false,
                                          );
                                        }
                                        _pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 100),
                                          curve: Curves.bounceIn,
                                        );
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 36,
                                        margin: EdgeInsets.only(left: 17),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 6),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.AppColor4,
                                                AppColors.AppColor2,
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          indexPage == 2
                                              ? "${AppLocalizations.of(context)!.getTranslate('homepage')}"
                                              : "${AppLocalizations.of(context)!.getTranslate('next_step')}",
                                          textAlign: TextAlign.center,
                                          style: AppTheme.TextIntroline16Text
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
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
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.02,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          // color: Colors.amber,
                          height: MediaQuery.of(context).size.height * 0.34,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(8),
                          child: AdsNative(
                            templateType: TemplateType.medium,
                            unitId: AdHelper.nativeInAppAdUnitId,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getIntroText(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return "intro1";
      case 1:
        return "intro2";
      case 2:
        return "intro3";

      default:
        return "intro1";
    }
  }

  buildPage(String image, String textIntro) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage(image), fit: BoxFit.fitWidth)),
      child: Stack(
        children: [
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     indexPage == 4
          //         ? Image.asset(
          //             image,
          //             fit: BoxFit.cover,
          //           )
          //         : SizedBox(),
          //   ],
          // ),
          // Container(
          //     padding: EdgeInsets.only(left: 18),
          //     margin: EdgeInsets.only(
          //         bottom: MediaQuery.of(context).size.height * 0.38),
          //     alignment: Alignment.bottomLeft,
          //     child: Text(
          //       "${AppLocalizations.of(context)!.getTranslate(textIntro)}",
          //       style: AppTheme.Intro20Text,
          //     )),
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
  ];
}
