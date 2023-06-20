import 'package:blood_sugar_tracking/views/home/record_info_slide_bar/record_info_slide_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../controllers/stores/sugar_info_store.dart';
import '../../../models/sugar_info/sugar_info.dart';

class RecordInfoSlideBarWidget extends StatefulWidget {
  RecordInfoSlideBarWidget({
    super.key,
  });

  @override
  State<RecordInfoSlideBarWidget> createState() =>
      _RecordInfoSlideBarWidgetState();
}

class _RecordInfoSlideBarWidgetState extends State<RecordInfoSlideBarWidget> {
  SugarInfoStore? sugarInfoStore;
  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: sugarInfoStore!.listRecord != null &&
                    sugarInfoStore!.listRecord!.isNotEmpty
                ? listRecordDisplay()
                : [Container()],
          ),
        ),
      );
    });
  }

  List<Widget> listRecordDisplay() {
    return sugarInfoStore!.listRecord!.map((e) {
      return RecordInfoSliderItemWidget(
        status: e.status,
        dayTime: e.dayTime,
        hourTime: e.hourTime,
        sugarAmount: e.sugarAmount,
      );
    }).toList();
  }
}
