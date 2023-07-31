import 'package:blood_sugar_tracking/models/information/information_provider.dart';
import 'package:blood_sugar_tracking/views/personal_data/item_personal_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../models/information/information.dart';
import '../../utils/locale/appLocalizations.dart';

class PersonalDataScreen extends StatefulWidget {
  // Information? information;
  PersonalDataScreen({
    super.key,
    //   this.information,
  });

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: AppColors.AppColor2,
        title: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: SvgPicture.asset(
                      Assets.iconBack,
                      height: 44,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${AppLocalizations.of(context)!.getTranslate('personal_data')}",
                    style: AppTheme
                        .Headline20Text, // Hiển thị dấu chấm ba khi có tràn
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Consumer<InformationNotifier>(builder: (context, provider, _) {
        InformationNotifier informationNotifier =
        Provider.of<InformationNotifier>(context);
        Information? information = provider.getUserData('information_key');
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 108,
                      margin: const EdgeInsets.only(left: 15, right: 8),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: AppColors.AppColor3,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Gender",
                                style: AppTheme.Headline16Text.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              SvgPicture.asset(Assets.iconEdit)
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          information != null
                              ? Text(
                            informationNotifier.informationList[0].gender.toString(),
                                  style: AppTheme.Headline20Text.copyWith(
                                      color: AppColors.AppColor4,
                                      fontWeight: FontWeight.w500),
                                )
                              : const Text('error')
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 108,
                      margin: const EdgeInsets.only(right: 15, left: 8),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: AppColors.AppColor3,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Age",
                                style: AppTheme.Headline16Text.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              SvgPicture.asset(Assets.iconEdit)
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          information != null ?  Text(
                            informationNotifier.informationList[0].old.toString(),
                            style: AppTheme.Headline20Text.copyWith(
                                color: AppColors.AppColor4,
                                fontWeight: FontWeight.w500),
                          ) : const Text('error')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 108,
                      margin: const EdgeInsets.only(left: 15, right: 8),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: AppColors.AppColor3,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Weight',
                                style: AppTheme.Headline16Text.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              SvgPicture.asset(Assets.iconEdit)
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          information != null ? Text(
                            '${informationNotifier.informationList[2].weight.toString()}' + '(kg)',
                            style: AppTheme.Headline20Text.copyWith(
                                color: AppColors.AppColor4,
                                fontWeight: FontWeight.w500),
                          ) : const Text("error")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 108,
                      margin: const EdgeInsets.only(right: 15, left: 8),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: AppColors.AppColor3,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Height",
                                style: AppTheme.Headline16Text.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              SvgPicture.asset(Assets.iconEdit)
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        information != null ?  Text(
                          '${informationNotifier.informationList[2].tall.toString()}' + '(cm)',
                            style: AppTheme.Headline20Text.copyWith(
                                color: AppColors.AppColor4,
                                fontWeight: FontWeight.w500),
                          ) : const Text('error')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
