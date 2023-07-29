import 'package:blood_sugar_tracking/views/personal_data/item_personal_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../models/information/information.dart';
import '../../utils/locale/appLocalizations.dart';

class PersonalDataScreen extends StatefulWidget {
  // Information? information;
  String? gender;
  String? name;

  PersonalDataScreen({super.key, this.gender, this.name
      //   this.information,
      });

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  List<Information> information = [];

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
        body:
            // body: information != null
            //     ? GridView.builder(
            //         gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            //             maxCrossAxisExtent: 200,
            //             childAspectRatio: 3 / 2,
            //             crossAxisSpacing: 20,
            //             mainAxisSpacing: 20),
            //         itemCount: information.length,
            //         itemBuilder: (BuildContext ctx, index) {
            //           return Container(
            //             height: double.infinity,
            //             width: double.infinity,
            //             decoration: BoxDecoration(
            //                 color: Colors.amber,
            //                 borderRadius: BorderRadius.circular(15)),
            //             child: Text(
            //               widget.name.toString(),
            //             ),
            //           );
            //         })
            //     : CircularProgressIndicator(),
            Container(
                height: 108,
                width: 164,
                margin: EdgeInsets.all(15),
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
                          widget.name.toString(),
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
                    Text(widget.gender.toString(),style: AppTheme.Headline20Text.copyWith(color: AppColors.AppColor4,fontWeight: FontWeight.w500),)
                  ],
                )));
  }
}
