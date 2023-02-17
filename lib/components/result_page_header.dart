import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/app_notifier.dart';
import '../providers/git_info_notifier.dart';

class ResultPageHeader extends StatelessWidget {
  const ResultPageHeader({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appNotifier);
    final selectedRecordCount = ref.watch(totalRecordCountProvider);
    return Container(
      color: Colors.blueGrey[100],
      padding: const EdgeInsets.fromLTRB(12, 20, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Scanned Directory: '),
          Expanded(child: Text(appState.currentDirectory)),
          const SizedBox(width: 8),
          Text('found $selectedRecordCount Repositories'),
        ],
      ),
    );
  }
}
