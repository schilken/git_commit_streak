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

}

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => PreferencesRepository(
    ref.read(sharedPreferencesProvider),
  ),
);
