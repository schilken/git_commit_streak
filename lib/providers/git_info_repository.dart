// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app_constants.dart';
import '../data/git_info_record.dart';
import '../utils/system_command.dart';

typedef HeatMap = Map<DateTime, int>;
typedef ProjectHeatMap = Map<String, HeatMap>;

class Streak {
  final DateTime startDate;
  final DateTime endDate;

  Streak({
    required this.startDate,
    required this.endDate,
  });

  int get length => endDate.difference(startDate).inDays;
}

// find . -type d -name ".git"
class GitInfoRepository {
  GitInfoRepository({
    required this.systemCommand,
  });

  final SystemCommand systemCommand;

  final ProjectHeatMap _projectHeatMap = {};
  String? currentDirectory;
  int maxGitMessages = AppConstants.maxGitMessages;

  Future<List<String>> _getGitDirectories(String directory) async {
    final arguments = [
      '.',
      '-type',
      'd',
      '-name',
      '.git',
    ];
    return systemCommand.runShellCommand(
      'find',
      arguments,
      directory,
    );
  }

  Future<List<String>> getGitLogForProject(String directoryPath) async {
    final parameters = [
      'log',
      '-n $maxGitMessages',
      '--pretty=%ci|%cn| %s',
    ];
    return systemCommand.runShellCommand(
      'git',
      parameters,
      directoryPath,
    );
  }

  GitInfoRecord? _createRecord(String projectName) {
    final heatMap = _projectHeatMap[projectName] ?? {};
    return GitInfoRecord(
      projectName: projectName,
      directoryPath: '$currentDirectory/$projectName',
      commitCountLast30days: _commitCountLastDays(heatMap, 30),
      commitCountToday: _commitCountLastDays(heatMap, 1),
      latestCommit: latestCommitFromHeatMap(heatMap),
      streakLength: streakLengthFromHeatMap(
        heatMap,
        DateTime.now(),
      ),
      timeRangeInDays: AppConstants.timeRangeInDays,
      heatMapData: _projectHeatMap[projectName] ?? {},
    );
  }

  DateTime latestCommitFromHeatMap(HeatMap heatMap) {
    if (heatMap.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    return heatMap.keys.first;
  }

  int _commitCountLastDays(HeatMap heatMap, int days) {
    var totalCount = 0;
    heatMap.forEach((date, commitCount) {
      if (date.isAfter(DateTime.now().subtract(Duration(days: days)))) {
        totalCount += commitCount;
      }
    });
    return totalCount;
  }

  Future<int> calcCommitCountOfToday(
    String baseDirectoryPath,
    String committerName,
  ) async {
    maxGitMessages = 10;
    await buildHeatMap(baseDirectoryPath, committerName);
    final overAllHeatMap = calculateOverAllHeatMap(_projectHeatMap);
    return _commitCountLastDays(overAllHeatMap, 1);
  }

  Future<List<GitInfoRecord>> scanGitRepos(
    String baseDirectoryPath,
    String committerName,
  ) async {
    if (committerName.isEmpty) {
      throw Exception('Committer name is not set');
    }
    maxGitMessages = AppConstants.maxGitMessages;
    final projectDirectoryPaths =
        await buildHeatMap(baseDirectoryPath, committerName);
    final records = projectDirectoryPaths
        .map((path) => _createRecord(projectNameFromPath(path)))
        .whereType<GitInfoRecord>()
        .cast<GitInfoRecord>()
        .toList();
    records.sort((a, b) => b.latestCommit.compareTo(a.latestCommit));
    insertOverallRecord(records, calculateOverAllHeatMap(_projectHeatMap));
    return records;
  }

  Future<Iterable<String>> buildHeatMap(
    String baseDirectoryPath,
    String committerName,
  ) async {
    _projectHeatMap.clear();
    currentDirectory = baseDirectoryPath;
    final projectDirectoryPaths = (await _getGitDirectories(baseDirectoryPath))
        .where((path) => path.isNotEmpty)
        .map((subdir) => '$baseDirectoryPath/$subdir'
            .replaceFirst('.git', '')
              .replaceFirst('./', ''),
        );
    for (final projectDirectory in projectDirectoryPaths) {
      final logLines = await getGitLogForProject(projectDirectory);
      final filteredLines = logLines
          .where((line) => line.isNotEmpty && line.contains(committerName));
      final heatMap = heatMapFromLines(filteredLines);
      _projectHeatMap[projectNameFromPath(projectDirectory)] = heatMap;
    }
    return projectDirectoryPaths;
  }

  void insertOverallRecord(
    List<GitInfoRecord> records,
    HeatMap overAllHeatMap,
  ) {
    records.insert(
      0,
      GitInfoRecord(
        projectName: 'All Projects',
        directoryPath: '$currentDirectory',
        commitCountLast30days: _commitCountLastDays(overAllHeatMap, 30),
        commitCountToday: _commitCountLastDays(overAllHeatMap, 1),
        latestCommit: latestCommitFromHeatMap(overAllHeatMap),
        streakLength: streakLengthFromHeatMap(
          overAllHeatMap,
          DateTime.now(),
        ),
        timeRangeInDays: AppConstants.timeRangeInDays,
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
    final dateTimeList =
        lines.map((line) => DateTime.parse(line.substring(0, 10))).toList();
    for (final element in dateTimeList) {
      heatMap.update(
        element,
        (value) => 1 + value,
        ifAbsent: () => 1,
      );
    }
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
        ),
      );
    }
    return totalHeatMap;
  }

  @visibleForTesting
  int streakLengthFromHeatMap(HeatMap heatMap, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    var dayCount = 0;
    var date = today;
    while (heatMap.containsKey(date)) {
      dayCount++;
      date = today.subtract(Duration(days: dayCount));
      // strip hour because of problem with summer/wintetime adjustment
      date = DateTime(date.year, date.month, date.day);
    }
    return dayCount;
  }

  int _countDaysInHeatMap(HeatMap heatMap, DateTime startDate) {
    var dayCount = 0;
    heatMap.forEach((date, commitCount) {
      if (date.isAfter(startDate)) {
        dayCount++;
      }
    });
    return dayCount;
  }

  int countDaysWithCommit({required int days}) {
    final overAllHeatMap = calculateOverAllHeatMap(_projectHeatMap);
    final dayCountWithCommit = _countDaysInHeatMap(
      overAllHeatMap,
      DateTime.now().subtract(Duration(days: days)),
    );
    return dayCountWithCommit;
  }

  Streak longestStreak() {
    return Streak(
        startDate: DateTime.now().subtract(Duration(days: 100)),
        endDate: DateTime.now());
  }
}

final gitInfoRepositoryProvider = Provider<GitInfoRepository>((ref) {
  final systemCommand = ref.watch(systemCommandProvider);
  return GitInfoRepository(systemCommand: systemCommand);
});
