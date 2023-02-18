// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers.dart';

class SettingsState {
  String committerName;

  SettingsState({
    required this.committerName,
  });

  SettingsState copyWith({
    String? committerName,
  }) {
    return SettingsState(
      committerName: committerName ?? this.committerName,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  late PreferencesRepository _preferencesRepository;

  @override
  SettingsState build() {
    debugPrint('SettingsNotifier');
    _preferencesRepository = ref.watch(preferencesRepositoryProvider);
    return SettingsState(
      committerName: _preferencesRepository.committerName,
    );
  }

  Future<void> setCommitterName(String name) async {
    debugPrint('setCommitterName |$name|');
    await _preferencesRepository.setCommitterName(name);
    state = state.copyWith(committerName: name);
  }

}

final settingsNotifier =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
