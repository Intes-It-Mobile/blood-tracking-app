import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../utils/locale/appLocalizations.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.AppColor1,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "${AppLocalizations.of(context)!.getTranslate('what_is_your_weight')}",
                  style: AppTheme.unit24Text,
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.067,
            child: InkWell(
              onTap: () {
                // Navigator.of(context).pushNamed(Routes.gender_screen);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalDataScreen(
                //   name: information[_selectedIndex].gender,
                // )));
              },
              child: Text(
                "${AppLocalizations.of(context)!.getTranslate('next')}",
                style: AppTheme.Headline20Text.copyWith(
                    color: AppColors.AppColor4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
