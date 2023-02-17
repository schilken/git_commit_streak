import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;

import '../data/git_info_record.dart';
import 'git_info_repository.dart';

typedef AsyncResult = AsyncValue<List<GitInfoRecord>?>;

class GitInfoNotifier extends AsyncNotifier<List<GitInfoRecord>?> {
  GitInfoNotifier();

  late GitInfoRepository _gitInfoRepository;
  final _records = <GitInfoRecord>[];

  @override
  FutureOr<List<GitInfoRecord>?> build() async {
    _gitInfoRepository = ref.read(gitInfoRepositoryProvider);
    return null;
  }

  Future<void> scan(String directory) async {
    _records.clear();
    state = const AsyncValue.loading();
    state = await AsyncResult.guard(
      () => _gitInfoRepository.scanGitRepos(directory),
    );
    _records.addAll(state.value ?? []);
  }

  bool get isLoading => state.isLoading;
}

final gitInfoNotifier =
    AsyncNotifierProvider<GitInfoNotifier, List<GitInfoRecord>?>(() {
  return GitInfoNotifier();
});

final totalRecordCountProvider = Provider<int>((ref) {
  final gitInfoAsyncValue = ref.watch(gitInfoNotifier);
  return gitInfoAsyncValue.maybeMap<int>(
      data: (data) {
        final records = data.value ?? [];
        return records.length;
      },
      orElse: () => 0);
});
