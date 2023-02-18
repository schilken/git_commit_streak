// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/git_info_record.dart';
import '../utils/git_log_utils.dart';
import '../utils/process_utils.dart';

typedef HeatMap = Map<DateTime, int>;
typedef ProjectHeatMap = Map<String, HeatMap>;

// find . -type d -name ".git"
class GitInfoRepository {
  String? currentDirectory;
  final _gitLogUtils = GitLogUtils();
  final ProjectHeatMap _projectHeatMap = {};
  

  Future<List<String>> _getGitDirectories(String directory) async {
    final arguments = [
      '.',
      '-type',
      'd',
      '-name',
      '.git',
    ];
    return runShellCommand(
      'find',
      arguments,
      directory,
    );
  }

  GitInfoRecord? _createRecord(String projectName) {
    return GitInfoRecord(
      projectName: projectName,
      directoryPath: '$currentDirectory/$projectName',
      commitCountLast30days: 0,
      latestCommit: DateTime.now(),
      streakLength: 0,
      timeRangeInDays: 180,
      heatMapData: _projectHeatMap[projectName] ?? {},
    );
  }

  Future<List<GitInfoRecord>> scanGitRepos(String baseDirectoryPath) async {
    final committerName = 'Alfred Schilken';
    if (committerName.isEmpty) {
      throw Exception('Committer name is not set');
    }
    currentDirectory = baseDirectoryPath;
    final projectDirectoryPaths = (await _getGitDirectories(baseDirectoryPath))
        .where((path) => path.isNotEmpty)
        .map((subdir) => '$baseDirectoryPath/$subdir'
            .replaceFirst('.git', '')
            .replaceFirst('./', ''));
    for (final projectDirectory in projectDirectoryPaths) {
      final logLines = await _gitLogUtils.getGitLogForProject(projectDirectory);
      final heatMap =
          heatMapFromLines(logLines.where((line) => line.isNotEmpty));
      _projectHeatMap[projectNameFromPath(projectDirectory)] = heatMap;
    }
//    debugPrint(_projectHeatMap.toString());
    final records = projectDirectoryPaths
        .map((path) => _createRecord(projectNameFromPath(path)))
        .whereType<GitInfoRecord>()
        .cast<GitInfoRecord>()
        .toList();
    return records;
  }

  String projectNameFromPath(String fullProjectPathName) {
    final strippedBaseFromPath =
        fullProjectPathName.replaceFirst('${currentDirectory!}/', '');
    return strippedBaseFromPath.substring(0, strippedBaseFromPath.length - 1);
  }

  @visibleForTesting
  HeatMap heatMapFromLines(Iterable<String> lines) {
    final heatMap = <DateTime, int>{};
    final List<DateTime> dateTimeList =
        lines.map((line) => DateTime.parse(line.substring(0, 10))).toList();
    dateTimeList.forEach((element) {
      heatMap.update(
        element,
        (value) => 1 + value,
        ifAbsent: () => 1,
      );
    });
    return heatMap;
  }

  @visibleForTesting
  HeatMap calculateOverAllHeatMap(ProjectHeatMap projectHeatMap) {
    final totalHeatMap = <DateTime, int>{};
    for (final heatMap in projectHeatMap.values) {
      heatMap.forEach((k, v) => totalHeatMap.update(
            k,
            (value) => v + value,
            ifAbsent: () => v,
          ));
    }
    return totalHeatMap;
  }

}

final gitInfoRepositoryProvider = Provider<GitInfoRepository>((ref) {
  final gitInfoRepository = GitInfoRepository();
  return gitInfoRepository;
});
