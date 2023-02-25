import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:git_commit_streak/utils/app_sizes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

import '../providers/app_notifier.dart';
import '../providers/git_info_notifier.dart';

class StatusBarContent extends StatelessWidget {
  const StatusBarContent({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appNotifier);
    final selectedRecordCount = ref.watch(totalRecordCountProvider);
    return Container(
      color: Colors.blueGrey[50],
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Scanned Directory: '),
          Expanded(child: Text(appState.currentDirectory)),
          gapWidth8,
          MacosIconButton(
            backgroundColor: Colors.transparent,
            icon: const MacosIcon(
//                        size: 32,
              CupertinoIcons.refresh,
            ),
            shape: BoxShape.circle,
            onPressed: () => ref
                .read(gitInfoNotifier.notifier)
                .scan(appState.currentDirectory),
          ),
          gapWidth8,
          Text('found $selectedRecordCount Repositories'),
        ],
      ),
    );
  }
}
