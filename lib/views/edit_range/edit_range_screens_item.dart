import 'package:flutter/material.dart';

import '../../utils/locale/appLocalizations.dart';

class EditRangeScreenItem extends StatefulWidget {
  String? title;
  String? name;
  double? low;
  double? normal;
  double? preDiabetes;
  double? diabetes;

  EditRangeScreenItem({
    Key? key,
    required this.title,
    required this.name,
    required this.low,
    required this.normal,
    required this.preDiabetes,
    required this.diabetes,
  }) : super(key: key);

  @override
  State<EditRangeScreenItem> createState() => _EditRangeScreenItemState();
}

class _EditRangeScreenItemState extends State<EditRangeScreenItem> {

  String? getTitle(String? value) {
    return AppLocalizations.of(context).getTranslate('${value}');
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
