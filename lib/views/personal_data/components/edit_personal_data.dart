import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/models/information/information.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/information/information_item.dart';
import '../../../models/information/information_provider.dart';
import '../../../utils/locale/appLocalizations.dart';

class EditPersonalData extends StatefulWidget {
  const EditPersonalData({super.key});

  @override
  State<EditPersonalData> createState() => _EditPersonalDataState();
}

class _EditPersonalDataState extends State<EditPersonalData> {
  int selectedIndex = -1;
  int value = 0;
  @override
  Widget build(BuildContext context) {
    InformationNotifier informationNotifier = Provider.of<InformationNotifier>(context);
    final Information information = informationNotifier.informations;
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          '${AppLocalizations.of(context)!.getTranslate('choose_your_gender')}',
          style: AppTheme.edit20Text,
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: ListInformation().information.length,
            itemBuilder: (context, int index) {
              return GestureDetector(
                onTap: (){
                  setState(() {
                    value = index;
                    if (selectedIndex == index) {
                      selectedIndex = 0;
                    } else {
                      selectedIndex = index;
                    }
                  });
                },
                child: Container(
                  height: 44,
                  margin:  EdgeInsets.only(top: 8, left: MediaQuery.of(context).size.width * 0.14, right: MediaQuery.of(context).size.width * 0.14),
                  decoration: BoxDecoration(
                      color: index == selectedIndex ? AppColors.AppColor2 : Colors.white,
                      borderRadius: BorderRadius.circular(22)),
                  child: Center(
                    child: Text(
                      ListInformation().information[index].gender.toString(),
                      style: AppTheme.Headline20Text.copyWith(
                        fontWeight: FontWeight.w600,
                        color:index == selectedIndex ? Colors.white : AppColors.AppColor2,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
         const Spacer(),
         Padding(
           padding: const EdgeInsets.only(bottom: 15),
           child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 45,
                    margin: const EdgeInsets.only(left: 15,right: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCFF3FF),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Center(
                      child: Text('${AppLocalizations.of(context)!.getTranslate('cancel')}',style: AppTheme.Headline16Text.copyWith(color: AppColors.AppColor2),),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: (){
                     String name = informationNotifier.informationList[0].gender.toString();
                     if(name.isNotEmpty && informationNotifier.informationList.isNotEmpty){
                       setState(() {
                         name = ListInformation().information[value].gender.toString();
                         ListInformation().information[value].gender = informationNotifier.informationList[0].gender.toString();
                       });
                     }
                     Information updatedTask = Information(gender: name);
                     informationNotifier.saveUserData('information_key', updatedTask);

                     print('edit gender list: ${informationNotifier.informationList[0].gender.toString()}');
                     print("edit gender: ${name}");
                     Navigator.pop(context);
                      //informationNotifier.saveUserData('information_key', updatedItem);

                  },
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.only(left: 12,right: 15),
                    decoration: BoxDecoration(
                        color: AppColors.AppColor2,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Center(
                      child: Text('${AppLocalizations.of(context)!.getTranslate('done')}',style: AppTheme.Headline16Text),
                    ),
                  ),
                ),
              ),
            ],
        ),
         )
      ],
    );
  }

}
