import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mixin_logger/mixin_logger.dart' as log;

import 'pages/main_view.dart';
import 'providers/providers.dart';

const loggerFolder = '/tmp/git_commit_streak_log';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final cron = Cron();
  cron.schedule(Schedule.parse('*/15 * * * *'), () async {
    log.i('cron task - every two minutes');
  });
  final pubspec = Pubspec.parse(await rootBundle.loadString('pubspec.yaml'));
  final version = pubspec.version;
//  debugPrint('version from pubspec.yaml: $version');
  await log.initLogger(loggerFolder);
  log.i('version from pubspec.yaml: $version');  
  sharedPreferences.setString('appVersion', version.toString());
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MainApp(),
    ),
  );
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
