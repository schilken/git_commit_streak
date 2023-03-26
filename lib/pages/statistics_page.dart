// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

import '../components/settings_controls_view.dart';
import '../providers/git_info_notifier.dart';
import '../utils/app_sizes.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            title: const Text('Commit Statistics'),
          ),
          children: [
            ContentArea(
              builder: (context, _) {
                return const Center(
                  child: StatisticsView(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class StatisticsView extends ConsumerWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(gitInfoNotifier.notifier);
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          gapHeight16,
          LabelAndValue(
            'Commits in the last 30 days',
            '${notifier.countDaysWithCommit(days: 30).value} → ${notifier.countDaysWithCommit(days: 30).inPercent}%',
          ),
          gapHeight16,
          LabelAndValue(
            'Commits in the last 180 days',
            '${notifier.countDaysWithCommit(days: 180).value} → ${notifier.countDaysWithCommit(days: 180).inPercent}%',
          ),
          gapHeight16,
          LabelAndValue(
            'Commits in the last 360 days',
            '${notifier.countDaysWithCommit(days: 360).value} → ${notifier.countDaysWithCommit(days: 360).inPercent}%',
          ),
          gapHeight16,
          LabelAndValue('Longest Streak', '${notifier.longestStreak()}'),
        ],
      ),
    );
  }
}

class LabelAndValue extends StatelessWidget {
  const LabelAndValue(
    this.label,
    this.value, {
    super.key,
  });
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: Text(label),
        ),
        Text(value),
      ],
    );
  }
}
