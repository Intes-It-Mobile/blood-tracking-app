import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/sugar_info/sugar_info.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';
import '../record_remind/record_remind_screens.dart';

class TopWidgetHomeContent extends StatefulWidget {
  const TopWidgetHomeContent({super.key});

  @override
  State<TopWidgetHomeContent> createState() => _TopWidgetHomeContentState();
}

class _TopWidgetHomeContentState extends State<TopWidgetHomeContent> {
  SugarInfoStore? sugarInfoStore;

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 7, 15, 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      child: SvgPicture.asset(Assets.iconRedCross),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context)!.getTranslate('app_name'),
                        style: AppTheme.Headline20Text,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                           Navigator.of(context).pushNamed(Routes.record_remind);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: AppColors.mainBgColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.all(6),
                          child: SvgPicture.asset(
                            Assets.iconAlarm,
                            height: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.history);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: AppColors.mainBgColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.fromLTRB(5.5, 8, 7, 8),
                          child: SvgPicture.asset(
                            Assets.iconHistory,
                            height: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 9),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: AppColors.mainBgColor,
                      ),
                      child: DropDownWidget(
                        listConditions:
                            sugarInfoStore!.listRootConditionsFilter,
                      )),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class DropDownWidget extends StatefulWidget {
  List<Conditions>? listConditions;

  DropDownWidget({super.key, required this.listConditions});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  SugarInfoStore? sugarInfoStore;
  String? selectedTitle = 'default_txt';
  int? selectedId = 0;
  List<String> types = [
    'default_txt',
    'before_exercise',
    'before_meal',
    'fasting',
    'after_meal_1h',
    "after_meal_2h",
    "after_exercise",
    "asleep"
  ];
  Conditions emptyItem = Conditions(id: -1, name: "all");
  String? selectedValue;
  bool showDropdown = false;
  List<Conditions>? listConditionsAll = [];
  String? getTitle(String? value) {
    return AppLocalizations.of(context)!.getTranslate('${value}');
  }

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    listConditionsAll = List.from(
        widget.listConditions!); // Tạo bản sao của widget.listConditions
    if (listConditionsAll!.length < 9) {
      listConditionsAll!.add(emptyItem);
    }
    super.didChangeDependencies();
  }

  void initState() {
    super.initState();

    // List<Conditions> listConditionsAll = List.from(widget.listConditions ?? []);

    // Sử dụng danh sách đã cập nhật dưới đây
    // ...
  }

  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: Text(
                getTitle(sugarInfoStore!.filterConditionTitle!)!,
                style: AppTheme.appBodyTextStyle.copyWith(
                    fontWeight: FontWeight.w700, color: AppColors.AppColor4),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: listConditionsAll!
            .map((Conditions item) => DropdownMenuItem<String>(
                  value: item.name,
                  child: Text(
                    getTitle(item.name!)!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          setState(() {
            sugarInfoStore!.setConditionFilterId(value!);
            // selectedValue = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 20,
          width: 80,
          // padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(14),

            color: AppColors.mainBgColor,
          ),
          elevation: 0,
        ),
        iconStyleData: IconStyleData(
          icon: SvgPicture.asset(Assets.iconType),
          iconSize: 14,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue,
          ),
          offset: const Offset(-20, -15),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          // padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
