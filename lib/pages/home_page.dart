import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

import '../components/async_value_widget.dart';
import '../components/record_list_view.dart';
import '../components/result_page_header.dart';
import '../providers/git_info_notifier.dart';
import '../providers/providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appNotifier);
    final gitInfoAsyncValue = ref.watch(gitInfoNotifier);
    return Builder(
      builder: (context) {
        return MacosScaffold(
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
            title: const Text('Commit Streak'),
            titleWidth: 250,
            actions: [
              createToolBarPullDownButton(ref, appState.currentDirectory),
            ],
          ),
          children: [
            ContentArea(
              builder: (context, _) {
                return Column(
                  children: [
                    ResultPageHeader(ref: ref),
                    Expanded(
                      child: AsyncValueWidget(
                          value: gitInfoAsyncValue,
                          data: (records) {
                            if (records == null) {
                              return const Center(
                                  child: Text('Not yet scanned'));
                            }
                            if (records.isEmpty) {
                              return const Center(
                                  child: Text('No directories found'));
                            }
                            return RecordListView(records, ref);
                          }),
                    ),
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

ToolBarPullDownButton createToolBarPullDownButton(
    WidgetRef ref, String currentDirectory) {
  return ToolBarPullDownButton(
    label: "Actions",
    icon: CupertinoIcons.ellipsis_circle,
    tooltipMessage: "Perform tasks with the selected items",
    items: [
      MacosPulldownMenuItem(
        title: const Text("Choose Folder"),
        onTap: () async {
          String? selectedDirectory =
              await FilePicker.platform.getDirectoryPath();
          if (selectedDirectory != null) {
            ref
                .read(appNotifier.notifier)
                .setCurrentDirectory(directoryPath: selectedDirectory);
            ref.read(gitInfoNotifier.notifier).scan(selectedDirectory);
          }
        },
      ),
      MacosPulldownMenuItem(
        title: const Text("Scan Directory"),
        onTap: () {
          ref.read(gitInfoNotifier.notifier).scan(currentDirectory);
        },
      ),
    ],
  );
}

