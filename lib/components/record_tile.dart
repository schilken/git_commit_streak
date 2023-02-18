// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

import '../app_constants.dart';
import '../data/git_info_record.dart';
import '../providers/providers.dart';
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
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.record.heatMapData.isNotEmpty) ...[
              Text(
                'Streak: ${widget.record.streakLength} days',
                style: MacosTheme.of(context).typography.title2,
              ),
              const SizedBox(height: 4),
              CapacityIndicator(
                value: 100.0 * math.min(widget.record.streakLength, 30) / 30.0,
                splits: 30,
                discrete: true,
              ),
              const SizedBox(height: 4),
              Text(
                  'Commits last 30 days: ${widget.record.commitCountLast30days}'),
              const SizedBox(height: 4),
              Text('Total commits: ${widget.record.totalCommitCount}'),
              const SizedBox(height: 4),
              Text(infoForSelectedDate ?? 'no date selected'),
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
