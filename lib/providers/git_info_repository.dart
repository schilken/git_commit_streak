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
      latestCommit: latestCommitFromHeatMap(_projectHeatMap[projectName] ?? {}),
      streakLength: streakLengthFromHeatMap(
        _projectHeatMap[projectName] ?? {},
        DateTime.now(),
      ),
      timeRangeInDays: 180,
      heatMapData: _projectHeatMap[projectName] ?? {},
    );
  }

  DateTime latestCommitFromHeatMap(HeatMap heatMap) {
    if (heatMap.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    return heatMap.keys.first;
  }

  Future<List<GitInfoRecord>> scanGitRepos(
    String baseDirectoryPath,
    String committerName,
  ) async {
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
      final filteredLines = logLines
          .where((line) => line.isNotEmpty && line.contains(committerName));
      final heatMap = heatMapFromLines(filteredLines);
      _projectHeatMap[projectNameFromPath(projectDirectory)] = heatMap;
    }
//    debugPrint(_projectHeatMap.toString());
    final records = projectDirectoryPaths
        .map((path) => _createRecord(projectNameFromPath(path)))
        .whereType<GitInfoRecord>()
        .cast<GitInfoRecord>()
        .toList();
    records.sort((a, b) => b.latestCommit.compareTo(a.latestCommit));
    insertOverallRecord(records, calculateOverAllHeatMap(_projectHeatMap));
    return records;
  }

  void insertOverallRecord(
      List<GitInfoRecord> records, HeatMap overAllHeatMap) {
    records.insert(
      0,
      GitInfoRecord(
        projectName: 'All Projects',
        directoryPath: '$currentDirectory',
        commitCountLast30days: 0,
        latestCommit: latestCommitFromHeatMap(overAllHeatMap),
        streakLength: streakLengthFromHeatMap(
          overAllHeatMap,
          DateTime.now(),
        ),
        timeRangeInDays: 180,
        heatMapData: overAllHeatMap,
      ),
    );
//          commitCountLast30days: _commitCountLast30days(overAllHeatMap),
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

  @visibleForTesting
  int streakLengthFromHeatMap(HeatMap heatMap, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    int dayCount = 0;
    var date = today;
    while (heatMap.containsKey(date)) {
      dayCount++;
      date = today.subtract(Duration(days: dayCount));
      // strip hour because of problem with summer/wintetime adjustment
      date = DateTime(date.year, date.month, date.day);
    }
    return dayCount;
  }
}

final gitInfoRepositoryProvider = Provider<GitInfoRepository>((ref) {
  final gitInfoRepository = GitInfoRepository();
  return gitInfoRepository;
});
