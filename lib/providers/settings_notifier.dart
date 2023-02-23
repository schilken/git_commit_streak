// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'notification_service.dart';
import 'providers.dart';

class SettingsState {
  String committerName;
  bool isReminderActive;

  SettingsState({
    required this.committerName,
    required this.isReminderActive,
  });

  SettingsState copyWith({
    String? committerName,
    bool? isReminderActive,
  }) {
    return SettingsState(
      committerName: committerName ?? this.committerName,
      isReminderActive: isReminderActive ?? this.isReminderActive,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  late PreferencesRepository _preferencesRepository;

  @override
  SettingsState build() {
    debugPrint('SettingsNotifier');
    _preferencesRepository = ref.watch(preferencesRepositoryProvider);
    if (_preferencesRepository.isReminderActive) {
      ref.read(notificationServiceProvider).init();
    }
    return SettingsState(
      committerName: _preferencesRepository.committerName,
      isReminderActive: _preferencesRepository.isReminderActive,
    );
  }

  Future<void> setCommitterName(String name) async {
    debugPrint('setCommitterName |$name|');
    await _preferencesRepository.setCommitterName(name);
    state = state.copyWith(committerName: name);
  }

  Future<void> setReminderActive(bool isActive) async {
    debugPrint('setReminderActive |$isActive|');
    await _preferencesRepository.setReminderActive(isActive);
    state = state.copyWith(isReminderActive: isActive);
    if (isActive) {
      ref.read(notificationServiceProvider).init();
      ref.read(notificationServiceProvider).requestPermissions();
    } else {
      ref.read(notificationServiceProvider).disable();
    }
  }

}

final settingsNotifier =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
