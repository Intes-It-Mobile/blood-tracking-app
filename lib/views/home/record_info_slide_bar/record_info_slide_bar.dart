
import 'package:blood_sugar_tracking/views/home/record_info_slide_bar/record_info_slide_bar_item.dart';
import 'package:flutter/cupertino.dart';

class RecordInfoSlideBarWidget extends StatefulWidget {
  const RecordInfoSlideBarWidget({super.key});

  @override
  State<RecordInfoSlideBarWidget> createState() =>
      _RecordInfoSlideBarWidgetState();
}

class _RecordInfoSlideBarWidgetState extends State<RecordInfoSlideBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            RecordInfoSliderItemWidget(
              status: 'normal',
            ),
            RecordInfoSliderItemWidget(
              status: 'diabetes',
            ),
            RecordInfoSliderItemWidget(
              status: 'pre_diabetes',
            ),
            RecordInfoSliderItemWidget(
              status: 'low',
            ),
          ],
        ),
      ),
    );
  }
}
