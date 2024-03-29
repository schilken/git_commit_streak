// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/filesystem_utils.dart';
import 'providers.dart';

@immutable
class AppState {
  final String message;
  final String appVersion;
  final String currentDirectory;

  const AppState({
    required this.message,
    required this.appVersion,
    required this.currentDirectory,
  });

  AppState copyWith({
    String? message,
    String? appVersion,
    String? currentDirectory,
  }) {
    return AppState(
      message: message ?? this.message,
      appVersion: appVersion ?? this.appVersion,
      currentDirectory: currentDirectory ?? this.currentDirectory,
    );
  }

  @override
  bool operator ==(covariant AppState other) {
    if (identical(this, other)) return true;

    return other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'AppState(message: $message)';
}

class AppNotifier extends Notifier<AppState> {
  late PreferencesRepository _preferencesRepository;

  @override
  AppState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    return AppState(
      message: 'initialized',
      appVersion: _preferencesRepository.appVersion,
      currentDirectory: _preferencesRepository.currentDirectory,
    );
  }

  void setCurrentDirectory({required String fullDirectoryPath}) {
    final reducedPath =
        FilesystemUtils().startWithUsersFolder(fullDirectoryPath);
    _preferencesRepository.setCurrentDirectory(reducedPath);
    state = state.copyWith(currentDirectory: reducedPath);
    debugPrint('setDefaultDirectory: $reducedPath');
  }
}

final appNotifier = NotifierProvider<AppNotifier, AppState>(AppNotifier.new);
