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
              child: FutureBuilder(
                future: ReadJsonData(),
                builder: (context, data) {
                  if (data.hasError) {
                    return Center(child: Text("${data.error}"));
                  } else if (data.hasData) {
                    var items = data.data;
                    return ListView.builder(
                        itemCount: items == null ? 0 :_items.length,
                        itemBuilder: (context, index) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.23,
                              width: double.infinity,
                              color: index.isEven || index == 0
                                  ? AppColors.AppColor3
                                  : Colors.white,

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          '${_items[index].conditions?[index].name}'),
                                      const Spacer(),
                                      SvgPicture.asset('assets/icons/ic_edit_pen.svg'),
                                      const SizedBox(
                                        width: 20,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                                Text(
                                                '${_items[index].conditions?[index].sugarAmount?[index].status}'),
                                            Text(
                                                '<'+'${_items[index].conditions?[index].sugarAmount?[index].minValue}'),
                                              ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${_items[index].conditions?[index].sugarAmount?[index].status}'),
                                            Text(
                                                '${_items[index].conditions?[index].sugarAmount?[index].minValue}'+'~'+'${_items[index].conditions?[index].sugarAmount?[index].maxValue}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${_items[index].conditions?[index].sugarAmount?[index].status}'),
                                            Text(
                                                '${_items[index].conditions?[index].sugarAmount?[index].minValue}'+'~'+'${_items[index].conditions?[index].sugarAmount?[index].maxValue}'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${_items[index].conditions?[index].sugarAmount?[index].status}'),
                                            Text(
                                                '>='+'${_items[index].conditions?[index].sugarAmount?[index].maxValue}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
          ],
        ));
  }
}
