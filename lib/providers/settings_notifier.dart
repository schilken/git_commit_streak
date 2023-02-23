// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'notification_service.dart';
import 'providers.dart';

class SettingsState {
  String committerName;
  bool isReminderActive;
  bool isSendIMessageActive;
  bool isApprovalActive;
  String recipientName;
  String reminderHhMm;
  String validationMessage;

  SettingsState({
    required this.committerName,
    required this.isReminderActive,
    required this.isSendIMessageActive,
    required this.isApprovalActive,
    required this.recipientName,
    required this.reminderHhMm,
    required this.validationMessage,
  });

  SettingsState copyWith({
    String? committerName,
    bool? isReminderActive,
    bool? isSendIMessageActive,
    bool? isApprovalActive,
    String? recipientName,
    String? reminderHhMm,
    String? validationMessage,
  }) {
    return SettingsState(
      committerName: committerName ?? this.committerName,
      isReminderActive: isReminderActive ?? this.isReminderActive,
      isSendIMessageActive: isSendIMessageActive ?? this.isSendIMessageActive,
      isApprovalActive: isApprovalActive ?? this.isApprovalActive,
      recipientName: recipientName ?? this.recipientName,
      reminderHhMm: reminderHhMm ?? this.reminderHhMm,
      validationMessage: validationMessage ?? this.validationMessage,
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
      isSendIMessageActive: _preferencesRepository.isSendIMessageActive,
      isApprovalActive: _preferencesRepository.isApprovalActive,
      recipientName: _preferencesRepository.recipientName,
      reminderHhMm: _preferencesRepository.reminderHhMm,
      validationMessage: '',
    );
  }

  Future<void> setCommitterName(String name) async {
    debugPrint('setCommitterName |$name|');
    await _preferencesRepository.setCommitterName(name);
    state = state.copyWith(committerName: name);
    validate();
  }

  Future<void> setRecipientName(String name) async {
    debugPrint('setRecipientName |$name|');
    await _preferencesRepository.setRecipientName(name);
    state = state.copyWith(recipientName: name);
    validate();
  }

  Future<void> setReminderHhMm(String hhMm) async {
    debugPrint('setReminderHhMm |$hhMm|');
    await _preferencesRepository.setReminderHhMm(hhMm);
    state = state.copyWith(reminderHhMm: hhMm);
    validate();
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
    validate();
  }

  Future<void> setSendIMessageActive(bool isActive) async {
    debugPrint('setSendIMessageActive |$isActive|');
    await _preferencesRepository.setSendIMessageActive(isActive);
    state = state.copyWith(isSendIMessageActive: isActive);
    validate();
  }

  Future<void> setApprovalActive(bool isActive) async {
    debugPrint('setApprovalActive |$isActive|');
    await _preferencesRepository.setApprovalActive(isActive);
    state = state.copyWith(isApprovalActive: isActive);
    validate();
  }

  validate() {
    if (state.reminderHhMm.length != 5) {
      state = state.copyWith(validationMessage: 'time is not set');
    } else if (state.isSendIMessageActive && state.recipientName.isEmpty) {
      state = state.copyWith(validationMessage: 'recipientName must be set');
    } else if (state.committerName.isEmpty) {
      state = state.copyWith(validationMessage: 'committerName must be set');
    } else {
      state = state.copyWith(validationMessage: '✅');
    }
  }


}

final settingsNotifier =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
