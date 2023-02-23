import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers.dart';

class PreferencesRepository {
  final SharedPreferences _prefs;

  PreferencesRepository(this._prefs);

  String get appVersion => _prefs.getString('appVersion') ?? '?';

  Future<void> setCurrentDirectory(String currentDirectory) async {
    await _prefs.setString('currentDirectory', currentDirectory);
  }

  String get currentDirectory {
    return _prefs.getString('currentDirectory') ?? '.';
  }

  Future<void> setCommitterName(String name) async {
    await _prefs.setString('committerName', name);
  }
  String get committerName {
    return _prefs.getString('committerName') ?? '';
  }

  Future<void> setReminderActive(bool isActive) async {
    await _prefs.setBool('isReminderActive', isActive);
  }

  bool get isReminderActive => _prefs.getBool('isReminderActive') ?? false;

  Future<void> setSendIMessageActive(bool isActive) async {
    await _prefs.setBool('isSendIMessageActive', isActive);
  }

  bool get isSendIMessageActive =>
      _prefs.getBool('isSendIMessageActive') ?? false;

  Future<void> setApprovalActive(bool isActive) async {
    await _prefs.setBool('isApprovalActive', isActive);
  }

  bool get isApprovalActive => _prefs.getBool('isApprovalActive') ?? false;

  Future<void> setRecipientName(String name) async {
    await _prefs.setString('recipientName', name);
  }

  String get recipientName {
    return _prefs.getString('recipientName') ?? '';
  }

  Future<void> setReminderHhMm(String name) async {
    await _prefs.setString('reminderHhMm', name);
  }

  String get reminderHhMm {
    return _prefs.getString('reminderHhMm') ?? '1900';
  }

}

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => PreferencesRepository(
    ref.read(sharedPreferencesProvider),
  ),
);
