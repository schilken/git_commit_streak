import 'package:flutter/cupertino.dart';
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
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (_, index) {
        final record = records[index];
        return Material(
          child: RecordTile(
            record: record,
          ),
        );
      },
    );
  }
}
