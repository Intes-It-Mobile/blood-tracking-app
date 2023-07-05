import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:blood_sugar_tracking/models/sugar_info/sugar_info.dart';
import 'package:provider/provider.dart';

import '../../../controllers/stores/sugar_info_store.dart';

class ScrollableChart extends StatefulWidget {
  List<SugarRecord> listRecords = [];

  ScrollableChart({super.key, required this.listRecords});

  @override
  _ScrollableChartState createState() => _ScrollableChartState();
}

class _ScrollableChartState extends State<ScrollableChart> {
  SugarInfoStore? sugarInfoStore;
  List<SugarRecord> listRecordsDisplay = [];
  ScrollController _scrollController = ScrollController();
  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);

    // listRecords = sugarInfoStore!.listRecordArrangedByTime!;

    super.didChangeDependencies();
  }
  List<SugarRecord> getListDisplay(List<SugarRecord> listInput){
        DateTime now = DateTime.now();
    DateTime startOfCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime startOfPreviousMonth = DateTime(now.year, now.month - 1, 1);
    DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);
    listRecordsDisplay = listInput.where((e) =>
            DateFormat("yyyy/MM/dd")
                .parse(e.dayTime!)
                .isAfter(startOfPreviousMonth) &&
            DateFormat("yyyy/MM/dd")
                .parse(e.dayTime!)
                .isBefore(startOfNextMonth))
        .toList();
        return listRecordsDisplay;
  }

  List<SugarRecord> listRecords = [
    SugarRecord(
        conditionId: 1,
        dayTime: "2023/06/23",
        hourTime: "00:01",
        id: 1,
        status: "diabetes",
        sugarAmount: 80),
    SugarRecord(
        conditionId: 1,
        dayTime: "2023/06/23",
        hourTime: "22:01",
        id: 1,
        status: "diabetes",
        sugarAmount: 120),
    SugarRecord(
        conditionId: 1,
        dayTime: "2023/06/24",
        hourTime: "16:30",
        id: 2,
        status: "diabetes",
        sugarAmount: 245),
    SugarRecord(
        conditionId: 2,
        dayTime: "2023/06/25",
        hourTime: "15:30",
        id: 3,
        status: "low",
        sugarAmount: 23),
    SugarRecord(
        conditionId: 0,
        dayTime: "2023/07/01",
        hourTime: "08:30",
        id: 4,
        status: "normal",
        sugarAmount: 175),
    SugarRecord(
        conditionId: 0,
        dayTime: "2023/07/12",
        hourTime: "08:30",
        id: 4,
        status: "normal",
        sugarAmount: 85),
    SugarRecord(
        conditionId: 0,
        dayTime: "2023/07/25",
        hourTime: "08:30",
        id: 4,
        status: "normal",
        sugarAmount: 123),
    SugarRecord(
        conditionId: 0,
        dayTime: "2023/08/11",
        hourTime: "08:30",
        id: 4,
        status: "normal",
        sugarAmount: 293),
    SugarRecord(
        conditionId: 0,
        dayTime: "2023/08/21",
        hourTime: "08:30",
        id: 4,
        status: "normal",
        sugarAmount: 479),
    SugarRecord(
        conditionId: 0,
        dayTime: "2023/08/24",
        hourTime: "08:30",
        id: 4,
        status: "normal",
        sugarAmount: 630),
  ];
  double maxSugarAmount = 0;
  List<TitleModel> leftTitles = [];
  int maxYAdjusted = 0;
  double chartHeight = 200;
  @override
  void initState() {
    super.initState();
    calculateMaxSugarAmount();
    generateLeftTitles();
    adjustMaxY();
  }

  void adjustMaxY() {
    double maxVisibleSugarAmount = maxSugarAmount;
  
    // Ensure that the maxYAdjusted value is divisible by 50
    maxYAdjusted = maxSugarAmount.toInt();
    for (var i = 0;; i++) {
      maxYAdjusted++;
      if (maxYAdjusted % 50 == 0) break;
    }
    // ((maxYAdjusted ~/ (maxSugarAmount / 50)) + 1) * (maxSugarAmount / 50);
  }

  void calculateMaxSugarAmount() {
    for (var record in getListDisplay(widget.listRecords)) {
      if (record.sugarAmount! > maxSugarAmount) {
        maxSugarAmount = record.sugarAmount!;
      }
    }
  }

  void generateLeftTitles() {
    double step = maxSugarAmount / 10;
    for (double i = 0; i <= maxSugarAmount; i += step) {
      leftTitles.add(TitleModel(title: i.toStringAsFixed(2)));
    }
    leftTitles = leftTitles.reversed
        .toList(); // Sắp xếp lại danh sách theo thứ tự tăng dần
  }

  DateTime convertStringToDate(String dateTime, String pattern) {
    return DateFormat(pattern).parse(dateTime);
  }

  List<FlSpot> data = [];
  @override
  Widget build(BuildContext context) {
    double maxSugarAmount = 0.0;
    for (var record in listRecordsDisplay) {
      if (record.sugarAmount! > maxSugarAmount) {
        maxSugarAmount = record.sugarAmount!;
      }
    }

    // List<TitleModel> leftTitles = [];
    double step = maxSugarAmount /
        10; // Khoảng cách giữa các giá trị là 1/10 của maxSugarAmount

    // leftTitles = leftTitles.reversed.toList();
    List<String> bottomTitles = [];
    DateTime currentDate = DateTime.now();
    DateTime firstDayOfPreviousMonth =
        DateTime(currentDate.year, currentDate.month - 1, 1);

    DateTime previousMonth =
        DateTime(currentDate.year, currentDate.month - 1, 1);
    DateTime nextMonth = DateTime(currentDate.year, currentDate.month + 1, 1);

    List<DateTime> months = [
      previousMonth,
      currentDate,
      nextMonth,
    ];
    for (int i = 0; i < 3; i++) {
      DateTime month = DateTime(
          firstDayOfPreviousMonth.year, firstDayOfPreviousMonth.month + i);
      int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      for (int day = 1; day <= daysInMonth; day++) {
        bottomTitles.add(day.toString());
      }
    }

    for (SugarRecord record in listRecordsDisplay) {
      DateTime dateTime = DateFormat("yyyy/MM/dd").parse(record.dayTime!);
      int daysSincePreviousMonth = dateTime.difference(previousMonth).inDays;
      double x = daysSincePreviousMonth.toDouble();
      double y = record.sugarAmount!.toDouble();
      data.add(FlSpot(x, y));
    }

    return Center(child: Observer(
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          height: chartHeight,
          child: listRecordsDisplay != null && listRecordsDisplay.isNotEmpty
              ? Row(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 7),
                        SizedBox(
                          height: 28.5,
                          child: Text(
                            maxYAdjusted.toString(),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 28.5,
                          child: Text(
                            (maxYAdjusted * 0.8).toInt().toString(),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 28.5,
                          child: Text(
                            (maxYAdjusted * 0.6).toInt().toString(),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 28.5,
                          child: Text(
                            (maxYAdjusted * 0.4).toInt().toString(),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 28.5,
                          child: Text(
                            (maxYAdjusted * 0.2).toInt().toString(),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 4000,
                          child: LineChart(
                            LineChartData(
                              borderData: FlBorderData(show: false),
                              rangeAnnotations: RangeAnnotations(
                                  verticalRangeAnnotations: [
                                    VerticalRangeAnnotation(x1: 60, x2: 61)
                                  ]),
                              minX: 0,
                              maxX: 90,
                              minY: 0,
                              maxY: (maxYAdjusted * 1.1).toDouble(),
                              backgroundColor: Colors.white,
                              lineBarsData: [
                                LineChartBarData(
                                    spots: listFlSpot(),
                                    isCurved: true,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF7CC5FA),
                                        Color(0xFF7CC5FA),
                                      ],
                                    ),
                                    barWidth: 2,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFF9ED4FA),
                                          // Colors.blueAccent.withOpacity(0.2),
                                          // Colors.blueAccent.withOpacity(0.9),
                                          // Color(0xFF9ED4FA),
                                          // Color(0xFF9ED4FA),
                                          Color(0xFF9ED4FA).withOpacity(0.2),
                                          Colors.white.withOpacity(0.2),
                                        ],
                                      ),
                                    ),
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                            radius: 2,
                                            strokeWidth: 3,
                                            strokeColor: Color(0xFF36ADEF),
                                            color: Colors.white);
                                      },
                                    )),
                              ],
                              gridData: FlGridData(
                                  horizontalInterval: 1.0,
                                  show: true,
                                  drawHorizontalLine: false,
                                  drawVerticalLine: true,
                                  getDrawingVerticalLine: (value) {
                                    return FlLine(
                                      color: Colors.grey.shade800,
                                      strokeWidth: 0.5,
                                    );
                                  }),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        interval: maxYAdjusted / 5,
                                        showTitles: false,
                                        getTitlesWidget: (value, meta) {
                                          return value <= maxYAdjusted
                                              ? Text(
                                                  value.toString().split('.')[
                                                      0], // Lấy phần số nguyên
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black),
                                                )
                                              : SizedBox();
                                        })

                                    // getTitlesWidget: (value, meta) {return Text(
                                    //         bottomTitles[intValue],
                                    //         style: TextStyle(
                                    //           color: Colors.black,
                                    //           fontSize: 10,
                                    //         ),
                                    //       )},

                                    ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                //xét text day bottom
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    interval: 1,
                                    showTitles: true,
                                    reservedSize: 32,
                                    getTitlesWidget: (value, meta) {
                                      int intValue = value.toInt();

                                      if (intValue >= 0 &&
                                          intValue < bottomTitles.length) {
                                        return Text(
                                          bottomTitles[intValue],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                          ),
                                        );
                                      }
                                      return SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        );
      },
    ));
  }

  List<FlSpot> listFlSpot() {
    return listRecordsDisplay.map((e) {
      {
        return FlSpot(
            calculateDateNumber("${e.dayTime} ${e.hourTime}")! -
                1 +
                calculateHourTime(e!.hourTime!)!
            // 1
            ,
            e.sugarAmount!.toDouble());
      }
    }).toList();
  }

  double? calculateHourTime(String hourTime) {
    List<String> parts = hourTime.split(':');
    int minutes = int.parse(parts[0]);
    int seconds = int.parse(parts[1]);
    double result = minutes + (seconds / 100);
    result = double.parse(result.toStringAsFixed(3));
    double resultA = result / 40;
    return resultA;
  }

  double? calculateDateNumber(String time) {
    DateTime currentDate = DateTime.now();
    DateTime specifiedDate = DateFormat('yyyy/MM/dd HH:mm').parse(time);
    double differenceValue = 0;

    int daysInThisMonth =
        DateTime(currentDate.year, currentDate.month + 1, 0).day;
    DateTime dayPreviousMonthDate =
        DateTime(currentDate.year, currentDate.month - 1, 1);
    int daysInPreviousMonth =
        DateTime(dayPreviousMonthDate.year, dayPreviousMonthDate.month + 1, 0)
            .day;

    differenceValue = ((currentDate.year - specifiedDate.year) * 12 +
            currentDate.month -
            specifiedDate.month) *
        1.0;
    switch (differenceValue) {
      case 1.0:
        return specifiedDate.day.toDouble();
      case -1.0:
        return specifiedDate.day.toDouble() +
            daysInThisMonth +
            daysInPreviousMonth;
      case 0:
        return specifiedDate.day.toDouble() + daysInPreviousMonth;
      default:
        throw RangeError("");
    }
  }
}

class TitleModel {
  final String title;

  TitleModel({required this.title});
}
