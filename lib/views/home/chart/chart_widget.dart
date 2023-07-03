import 'package:blood_sugar_tracking/models/sugar_info/sugar_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_theme.dart';
import '../../../constants/colors.dart';
import '../../../controllers/stores/sugar_info_store.dart';
import '../../../utils/locale/appLocalizations.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SugarChartRecord {
  final String time;
  final int value;

  SugarChartRecord({required this.time, required this.value});
}

class LineChart extends StatefulWidget {
  LineChart({
    super.key,
  });

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  SugarInfoStore? sugarInfoStore;
  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.getTranslate('chart'),
            style: AppTheme.BtnText.copyWith(color: AppColors.AppColor2),
          ),
          SizedBox(
            height: 10,
          ),
          Observer(builder: (_) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              height: 200,
              margin: EdgeInsets.all(16.0),
              child: sugarInfoStore!.listRecordArrangedByTime != null &&
                      sugarInfoStore!.listRecordArrangedByTime!.isNotEmpty
                  ? SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(
                        interval: 30,
                        majorTickLines: MajorTickLines(size: 0),
                      ),
                      series: <ChartSeries>[
                        LineSeries<SugarChartRecord, String>(
                          dataSource: listData(),
                          xValueMapper: (SugarChartRecord record, _) =>
                              record.time,
                          yValueMapper: (SugarChartRecord record, _) =>
                              record.value,
                          markerSettings: MarkerSettings(isVisible: true),
                          enableTooltip: true, // Bật tooltip
                        ),
                      ],
                      tooltipBehavior: TooltipBehavior(
                        enable: true, // Bật tooltip cho biểu đồ
                        header: 'Data',
                        format: 'Time: point.x  \nSugar Amount: point.y',
                      ), // Bật tooltip cho biểu đồ
                    )
                  : Container(),
            );
          }),
        ],
      ),
    );
  }

  List<SugarChartRecord> listData() {
    return sugarInfoStore!.listRecordArrangedByTime!.reversed.map((e) {
      return SugarChartRecord(
          time: "${e.hourTime}\n${e.dayTime} ", value: e.sugarAmount!.toInt());
    }).toList();
  }
}
