import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/git_info_record.dart';
import 'record_tile.dart';

class RecordListView extends StatelessWidget {
  const RecordListView(
    this.records,
    this.ref, {
    super.key,
  });
  final List<GitInfoRecord> records;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: records.length,
      itemBuilder: (_, index) {
        final record = records[index];
        return Material(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RecordTile(
              record: record,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 0,
          thickness: 2,
        );
      },

    );
  }
}
