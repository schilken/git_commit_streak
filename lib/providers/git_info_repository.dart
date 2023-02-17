// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/git_info_record.dart';

// find . -type d -name ".git"
class GitInfoRepository {
  String? currentDirectory;

  Future<List<String>> _getGitDirectories(String directory) async {
    const executable = 'find';
    final arguments = [
      '.',
      '-type',
      'd',
      '-name',
      '.git',
    ];
    final process = await Process.run(
      executable,
      arguments,
      workingDirectory: directory,
    );
    if (process.exitCode != 0) {
      debugPrint('stderr: ${process.stderr}');
      return [];
    } else {
      final lines = process.stdout.split('\n');
      return lines;
    }
  }

  GitInfoRecord? _createRecord(String pathName) {
    return GitInfoRecord(
      projectName: pathName.replaceFirst('/.git', '').replaceFirst('./', ''),
      directoryPath: pathName.trim().replaceFirst('./', ''),
      commitCountLast30days: 0,
      latestCommit: DateTime.now(),
      streakLength: 0,
      timeRangeInDays: 180,
    );
  }

  Future<List<GitInfoRecord>> scanGitRepos(String directoryPath) async {
    currentDirectory = directoryPath;
    final directoryPaths = await _getGitDirectories(
      directoryPath,
    );
    // discUsageLines.forEach((element) {
    //   debugPrint(element);
    // });
    final records = directoryPaths
        .map((path) => _createRecord(path))
        .whereType<GitInfoRecord>()
        .cast<GitInfoRecord>()
        .toList();
    return records;
  }
}

final gitInfoRepositoryProvider = Provider<GitInfoRepository>((ref) {
  final gitInfoRepository = GitInfoRepository();
  return gitInfoRepository;
});
