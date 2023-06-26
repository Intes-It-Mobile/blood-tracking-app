import 'dart:convert';
import 'dart:developer';

import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/sugar_info/sugar_info.dart';
import '../../utils/locale/appLocalizations.dart';
import 'package:flutter/services.dart' as rootBundle;

class EditRangeScreens extends StatefulWidget {
  const EditRangeScreens({Key? key}) : super(key: key);

  @override
  State<EditRangeScreens> createState() => _EditRangeScreensState();
}

class _EditRangeScreensState extends State<EditRangeScreens> {
  SugarInfoStore? sugarInfoStore;
  List<Conditions>? listRootConditions;

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    listRootConditions = sugarInfoStore!.listRootConditions;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
   // ReadJsonData();
    super.initState();
  }

  List<SugarInfo> _items = [];

  Future<List<SugarInfo>> ReadJsonData() async {
    final jsonData = await rootBundle.rootBundle
        .loadString('assets/json/default_conditions.json');
    final list = json.decode(jsonData);

    final a = SugarInfo.fromJson(list);
    _items.add(a);
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          backgroundColor: AppColors.AppColor2,
          title: Container(
            child: Column(
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
                        "${AppLocalizations.of(context)!.getTranslate('edit_target_range')}",
                        style: AppTheme.Headline20Text,
                        overflow: TextOverflow
                            .ellipsis, // Hiển thị dấu chấm ba khi có tràn
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.086,
              width: double.infinity,
              color: AppColors.AppColor4,
              child: Text(
                "${AppLocalizations.of(context)!.getTranslate('notification')}",
                style: AppTheme.hintText.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
                textAlign: TextAlign.justify,
                maxLines: 3,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: sugarInfoStore!.listRootConditions?.length,
                  itemBuilder: (context, index) {
                    print('_items: ${_items.length}');
                    return sugarInfoStore!.listRootConditions!.length <= 8
                        ? Container(
                            height:
                                MediaQuery.of(context).size.height * 0.23,
                            width: double.infinity,
                            color: index.isEven || index == 0
                                ? AppColors.AppColor3
                                : Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.getTranslate('${sugarInfoStore!.listRootConditions?[index].name}')}',
                                      style: AppTheme.hintText.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    ),
                                    // const Spacer(),
                                    // SvgPicture.asset(
                                    //     'assets/icons/ic_edit_pen.svg'),
                                    // const SizedBox(
                                    //   width: 20,
                                    // )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${AppLocalizations.of(context)!.getTranslate('${sugarInfoStore!.listRootConditions?[index].sugarAmount?[0].status}')}',
                                                style: AppTheme.hintText
                                                    .copyWith(
                                                        color: Color(
                                                            0xFF0084FF),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12)),
                                            Text(
                                                '<' +
                                                    '${sugarInfoStore!.listRootConditions?[index].sugarAmount?[0].minValue}',
                                                style: AppTheme.hintText
                                                    .copyWith(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${AppLocalizations.of(context)!.getTranslate('${sugarInfoStore!.listRootConditions?[index].sugarAmount?[1].status}')}',
                                              style: AppTheme.hintText
                                                  .copyWith(
                                                      color:
                                                          Color(0xFF0EB500),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12)),
                                          Text(
                                              '${sugarInfoStore!.listRootConditions?[index].sugarAmount?[1].minValue}' +
                                                  '~' +
                                                  '${sugarInfoStore!.listRootConditions?[index].sugarAmount?[1].maxValue}',
                                              style: AppTheme.hintText
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${AppLocalizations.of(context)!.getTranslate('${sugarInfoStore!.listRootConditions?[index].sugarAmount?[2].status}')}',
                                                style: AppTheme.hintText
                                                    .copyWith(
                                                        color: Color(
                                                            0xFFFF8A00),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12)),
                                            Text(
                                                '${sugarInfoStore!.listRootConditions?[index].sugarAmount?[2].minValue}' +
                                                    '~' +
                                                    '${sugarInfoStore!.listRootConditions?[index].sugarAmount?[2].maxValue}',
                                                style: AppTheme.hintText
                                                    .copyWith(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${AppLocalizations.of(context)!.getTranslate('${sugarInfoStore!.listRootConditions?[index].sugarAmount?[3].status}')}',
                                              style: AppTheme.hintText
                                                  .copyWith(
                                                      color:
                                                          Color(0xFFB5000B),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12)),
                                          Text(
                                              '>=' +
                                                  '${sugarInfoStore!.listRootConditions?[index].sugarAmount?[3].maxValue}',
                                              style: AppTheme.hintText
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ))
                        : const Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
            )
          ],
        ));
  }
}
