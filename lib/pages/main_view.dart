import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

import '../providers/app_notifier.dart';
import '../providers/git_info_notifier.dart';
import '../providers/reminder_provider.dart';
import 'help_page.dart';
import 'home_page.dart';
import 'settings_page.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  int _pageIndex = 0;
  late Reminder reminder;
  final appLegalese = '© ${DateTime.now().year} Alfred Schilken';
  final apppIcon = Image.asset(
    'assets/images/icon_32x32@2x.png',
    width: 64.0,
    height: 64.0,
  );

  @override
  void initState() {
    Future<void>.delayed(const Duration(milliseconds: 100), () {
      final currentDirectory = ref.watch(appNotifier).currentDirectory;
      ref.read(gitInfoNotifier.notifier).scan(currentDirectory);
      reminder = ref.watch(reminderProvider);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appNotifier);
    return MacosWindow(
      sidebar: Sidebar(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
        ),
        minWidth: 200,
        bottom: MacosListTile(
          leading: const MacosIcon(CupertinoIcons.info_circle),
          title: const Text('GitCommitStreak'),
          subtitle: Text('Version ${appState.appVersion}'),
          onClick: () => showLicensePage(
            context: context,
            applicationLegalese: appLegalese,
            applicationIcon: apppIcon,
          ),
        ),
        builder: (context, scrollController) => SidebarItems(
          currentIndex: _pageIndex,
          onChanged: (index) {
            setState(() => _pageIndex = index);
          },
          items: const [
            SidebarItem(
              leading: MacosIcon(CupertinoIcons.home),
              label: Text('Commits Heat Map'),
            ),
            SidebarItem(
              leading: MacosIcon(CupertinoIcons.info),
              label: Text('Help'),
            ),
            SidebarItem(
              leading: MacosIcon(CupertinoIcons.gear),
              label: Text('Settings'),
            ),
          ],
        ),
      ),
      child: IndexedStack(
        index: _pageIndex,
        children: const [
          HomePage(),
          HelpPage(),
          SettingsPage(),
        ],
      ),
    );
  }
}
