// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:macos_ui/macos_ui.dart';

import '../components/async_value_widget.dart';
import '../components/record_list_view.dart';
import '../components/status_bar_content.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appNotifier);
    final gitInfoAsyncValue = ref.watch(gitInfoNotifier);
    return Builder(
      builder: (context) {
        return MacosScaffold(
          backgroundColor: Colors.white,
          toolBar: ToolBar(
            leading: MacosIconButton(
              icon: const MacosIcon(
                CupertinoIcons.sidebar_left,
                size: 40,
                color: CupertinoColors.black,
              ),
              onPressed: () {
                MacosWindowScope.of(context).toggleSidebar();
              },
            ),
            titleWidth: 450,
            title: Row(
              children: [
                const Text('Git Commit Streak'),
                gapWidth12,
                const Text('–'),
                gapWidth12,
                CommitsToday(ref: ref),
                gapWidth12,
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
              ],
            ),
            actions: [
              createToolBarPullDownButton(ref, appState.currentDirectory),
            ],
          ),
          children: [
            ContentArea(
              builder: (context, _) {
                return Column(
                  children: [
                    Expanded(
                      child: AsyncValueWidget(
                        value: gitInfoAsyncValue,
                        data: (records) {
                          if (records == null) {
                            return const Center(
                              child: Text('Not yet scanned'),
                            );
                          }
                          if (records.isEmpty) {
                            return const Center(
                              child: Text('No directories found'),
                            );
                          }
                          return RecordListView(records, ref);
                        },
                      ),
                    ),
                    ResizablePane(
                      minSize: 50,
                      startSize: 50,
                      isResizable: false,
                      //windowBreakpoint: 600,
                      builder: (_, __) {
                        return StatusBarContent(ref: ref);
                      },
                      resizableSide: ResizableSide.top,
                    )
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class CommitsToday extends StatelessWidget {
  const CommitsToday({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final countAsyncValue = ref.watch(todayCommitCountAsyncProvider);
    final todayAsMMdd = DateFormat("yyyy-MM-dd").format(DateTime.now());
    return AsyncValueWidget(
      value: countAsyncValue,
      spinnerRadius: 10,
      data: (count) {
        return count == 0
            ? Text(
                'Not yet committed today($todayAsMMdd)',
                style: TextStyle(color: Colors.red),
              )
            : Text('$count commits today($todayAsMMdd)👍');
      },
    );
  }
}

ToolBarPullDownButton createToolBarPullDownButton(
  WidgetRef ref,
  String currentDirectory,
) {
  final userHomeDirectory = Platform.environment['HOME'];
  return ToolBarPullDownButton(
    label: 'Actions',
    icon: CupertinoIcons.ellipsis_circle,
    tooltipMessage: 'Perform tasks with the selected items',
    items: [
      MacosPulldownMenuItem(
        title: const Text('Choose Folder'),
        onTap: () async {
          final selectedDirectory = await FilePicker.platform.getDirectoryPath(
            initialDirectory: userHomeDirectory,
          );
          if (selectedDirectory != null) {
            ref
                .read(appNotifier.notifier)
                .setCurrentDirectory(fullDirectoryPath: selectedDirectory);
            ref.read(gitInfoNotifier.notifier).scan(selectedDirectory);
          }
        },
      ),
      MacosPulldownMenuItem(
        title: const Text('Scan Directory'),
        onTap: () {
          ref.read(gitInfoNotifier.notifier).scan(currentDirectory);
        },
      ),
    ],
  );
}
