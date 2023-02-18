import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';

class HeatMapWidget extends StatelessWidget {
  final Map<DateTime, int> heatMapData;
  final StringCallback onClick;
  final int timeRangeInDays;
  const HeatMapWidget(
    this.heatMapData,
    this.timeRangeInDays,
    this.onClick, {
    super.key,
  });

  _onClick(DateTime date) {
    onClick(
        '${DateFormat("yyyy-MM-dd").format(date)} : ${heatMapData[date] ?? 'no'} commits');
  }

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: DateTime.now().subtract(Duration(days: timeRangeInDays)),
      endDate: DateTime.now(),
      datasets: heatMapData,
      colorMode: ColorMode.color,
      showText: false,
      scrollable: true,
      colorsets: {
        1: Colors.green.shade100,
        3: Colors.green.shade200,
        5: Colors.green.shade300,
        7: Colors.green.shade400,
        10: Colors.green.shade500,
        14: Colors.green.shade600,
        20: Colors.green.shade900,
      },
      onClick: _onClick,
    );
  }
}
