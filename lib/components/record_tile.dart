// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import '../data/git_info_record.dart';
import '../utils/app_sizes.dart';
import 'heat_map_widget.dart';

class RecordTile extends StatefulWidget {
  const RecordTile({
    super.key,
    required this.record,
  });
  final GitInfoRecord record;

  @override
  State<RecordTile> createState() => _RecordTileState();
}

class _RecordTileState extends State<RecordTile> {
  String? infoForSelectedDate;
  @override
  Widget build(BuildContext context) {
    return MacosListTile(
      title: Row(
        children: [
          Text(
            widget.record.projectName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.record.heatMapData.isNotEmpty) ...[
              Text(
                'Streak: ${widget.record.streakLength} days',
                style: MacosTheme.of(context).typography.title2,
              ),
              gapHeight4,
              CapacityIndicator(
                value: 100.0 * math.min(widget.record.streakLength, 30) / 30.0,
                splits: 30,
                discrete: true,
              ),
              gapHeight4,
              Text(
                'Commits Total: ${widget.record.totalCommitCount} – last month: ${widget.record.commitCountLast30days} – today: ${widget.record.commitCountToday}',
              ),
              gapHeight4,
              Text(infoForSelectedDate ?? 'No date selected'),
              HeatMapWidget(
                  widget.record.heatMapData, widget.record.timeRangeInDays,
                  (info) {
                setState(() {
                  infoForSelectedDate = info;
                });
              }),
            ],
          ],
        ),
      ),
    );
  }
}
