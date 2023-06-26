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
<<<<<<< HEAD
  List<EditTargetRange> editTargetRange = [
    EditTargetRange(name: 'Default', max: 7.0, min: 4.0),
    EditTargetRange(name: 'Before exercise', max: 8.5, min: 4.0),
    EditTargetRange(name: 'Before a meal', max: 7.0, min: 4.0),
    EditTargetRange(name: 'After a meal (1h)', max: 8.5, min: 4.0),
    EditTargetRange(name: 'After a meal (2h)', max: 7.0, min: 4.0),
    EditTargetRange(name: 'After exercise', max: 7.0, min: 4.0),
    EditTargetRange(name: 'Asleep', max: 8.0, min: 4.5),
  ];
=======
>>>>>>> 8d20a8e891f8af8a2c6ec6f3a29dccc33dec2ba6

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    listRootConditions = sugarInfoStore!.listRootConditions;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    ReadJsonData();
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
<<<<<<< HEAD
              child: ListView.builder(
                  primary: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: editTargetRange.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.24,
                      width: double.infinity,
                      color: index.isEven || index == 0
                          ? AppColors.AppColor3
                          : Colors.white,
                      padding: const EdgeInsets.only(top: 12, left: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                editTargetRange[index].name,
                                style: AppTheme.hintText.copyWith(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                              const Spacer(),
                              SvgPicture.asset(Assets.iconEditRange),
                              const SizedBox(
                                width: 24,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${AppLocalizations.of(context)!.getTranslate('low')}",
                                        style: AppTheme.hintText.copyWith(
                                            fontSize: 12,
                                            color: AppColors.LowStt,
                                            fontWeight: FontWeight.w700),
                                        // Hiển thị dấu chấm ba khi có tràn
                                        maxLines: 2,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text('<' +
                                          '${editTargetRange[index].min.toString()}'),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
=======
              child: FutureBuilder(
                future: ReadJsonData(),
                builder: (context, data) {
                  return ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        print('_items: ${_items.length}');
                        return _items.length <= 8
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                width: double.infinity,
                                color: index.isEven || index == 0
                                    ? AppColors.AppColor3
                                    : Colors.white,
>>>>>>> 8d20a8e891f8af8a2c6ec6f3a29dccc33dec2ba6
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
                                          '${AppLocalizations.of(context)!.getTranslate('${_items[index].conditions?[index].name}')}',
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
                                                    '${AppLocalizations.of(context)!.getTranslate('${_items[index].conditions?[index].sugarAmount?[0].status}')}',
                                                    style: AppTheme.hintText
                                                        .copyWith(
                                                            color: Color(
                                                                0xFF0084FF),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12)),
                                                Text(
                                                    '<' +
                                                        '${_items[index].conditions?[index].sugarAmount?[0].minValue}',
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
                                                  '${AppLocalizations.of(context)!.getTranslate('${_items[index].conditions?[index].sugarAmount?[1].status}')}',
                                                  style: AppTheme.hintText
                                                      .copyWith(
                                                          color:
                                                              Color(0xFF0EB500),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 12)),
                                              Text(
                                                  '${_items[index].conditions?[index].sugarAmount?[1].minValue}' +
                                                      '~' +
                                                      '${_items[index].conditions?[index].sugarAmount?[1].maxValue}',
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
                                                    '${AppLocalizations.of(context)!.getTranslate('${_items[index].conditions?[index].sugarAmount?[2].status}')}',
                                                    style: AppTheme.hintText
                                                        .copyWith(
                                                            color: Color(
                                                                0xFFFF8A00),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12)),
                                                Text(
                                                    '${_items[index].conditions?[index].sugarAmount?[2].minValue}' +
                                                        '~' +
                                                        '${_items[index].conditions?[index].sugarAmount?[2].maxValue}',
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
                                                  '${AppLocalizations.of(context)!.getTranslate('${_items[index].conditions?[index].sugarAmount?[3].status}')}',
                                                  style: AppTheme.hintText
                                                      .copyWith(
                                                          color:
                                                              Color(0xFFB5000B),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 12)),
                                              Text(
                                                  '>=' +
                                                      '${_items[index].conditions?[index].sugarAmount?[3].maxValue}',
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
<<<<<<< HEAD
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ),
=======
                                ))
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                      });
                },
              ),
            )
>>>>>>> 8d20a8e891f8af8a2c6ec6f3a29dccc33dec2ba6
          ],
        ));
  }
}
