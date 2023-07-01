import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:blood_sugar_tracking/models/sugar_info/sugar_info.dart';

class ScrollableChart extends StatefulWidget {
  const ScrollableChart({super.key});

  @override
  _ScrollableChartState createState() => _ScrollableChartState();
}

class _ScrollableChartState extends State<ScrollableChart> {
  List<SugarRecord> listRecords = [
    SugarRecord(
        conditionId: 1,
        dayTime: "2023/05/23",
        hourTime: "08:30",
        id: 1,
        status: "diabetes",
        sugarAmount: 80),
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
        conditionId: 2,
        dayTime: "2023/06/26",
        hourTime: "15:30",
        id: 3,
        status: "low",
        sugarAmount: 95),
    SugarRecord(
        conditionId: 0,
        dayTime: "2023/06/27",
        hourTime: "08:30",
        id: 4,
        status: "normal",
        sugarAmount: 125),
  ];
  DateTime convertStringToDate(String dateTime, String pattern) {
    return DateFormat(pattern).parse(dateTime);
  }

  List<FlSpot> data = [];
  @override
  Widget build(BuildContext context) {
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

    for (SugarRecord record in listRecords) {
      DateTime dateTime = DateFormat("yyyy/MM/dd").parse(record.dayTime!);
      int daysSincePreviousMonth = dateTime.difference(previousMonth).inDays;
      double x = daysSincePreviousMonth.toDouble();
      double y = record.sugarAmount!.toDouble();
      data.add(FlSpot(x, y));
    }

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 250,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1500,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 90,
                minY: 0,
                maxY: 300,
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
                        getDotPainter: (spot, percent, barData, index) {
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
                    sideTitles: SideTitles(showTitles: true),
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
                        var listSugarAmountDay = new List<int>.generate(10, (i) => i + 1);
                        if (intValue >= 0 && intValue < bottomTitles.length) {
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
    );
  }

  List<FlSpot> listFlSpot() {
    return listRecords.map((e) {
      {
        return FlSpot(DateFormat('yyyy/MM/dd').parse(e.dayTime!).day.toDouble(),
            e.sugarAmount!.toDouble());
      }
    }).toList();
  }
}
