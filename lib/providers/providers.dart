import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'app_notifier.dart';
export 'cron_provider.dart';
export 'cron_service.dart';
export 'git_info_notifier.dart';
export 'git_info_repository.dart';
export 'notification_service.dart';
export 'preferences_repository.dart';
export 'reminder_provider.dart';
export 'settings_notifier.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
  name: 'SharedPreferencesProvider',
);
