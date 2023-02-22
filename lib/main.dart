import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mixin_logger/mixin_logger.dart' as log;

import 'pages/main_view.dart';
import 'providers/providers.dart';
import 'providers/reminder_provider.dart';

const loggerFolder = '/tmp/git_commit_streak_log';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final pubspec = Pubspec.parse(await rootBundle.loadString('pubspec.yaml'));
  final version = pubspec.version;
  await log.initLogger(loggerFolder);
  final isCheckCommitStreak =
      Platform.environment['CHECK_COMMIT_STREAK'] ?? 'false';
  log.i(
      'version from pubspec.yaml: $version, isCheckCommitStreak: $isCheckCommitStreak');

  sharedPreferences.setString('appVersion', version.toString());
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
//    observers: [AsyncErrorLogger()],
  );
  if (isCheckCommitStreak == 'true') {
    await container.read(reminderProvider).checkCommitsOfToday();
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    log.i('before SystemNavigator.pop');
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  log.i(
      'bundleID: ${packageInfo.packageName} executable: ${Platform.resolvedExecutable}');
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MacosApp(
      title: 'GitCommitStreak',
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const MainView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
