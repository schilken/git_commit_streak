// ignore_for_file: public_member_api_docs, sort_constructors_first
class GitInfoRecord {
  final String projectName;
  final String directoryPath;
  final Map<DateTime, int> heatMapData;
  final DateTime latestCommit;
  final int streakLength;
  final int timeRangeInDays;
  final int commitCountLast30days;
  final int commitCountToday;

  GitInfoRecord({
    required this.projectName,
    required this.directoryPath,
    this.heatMapData = const {},
    required this.latestCommit,
    required this.streakLength,
    required this.timeRangeInDays,
    required this.commitCountLast30days,
    required this.commitCountToday,
  });

  int get totalCommitCount =>
      heatMapData.values.reduce((sum, val) => sum + val);

  GitInfoRecord copyWith({
    String? projectName,
    String? directoryPath,
    Map<DateTime, int>? heatMapData,
    DateTime? latestCommit,
    int? streakLength,
    int? timeRangeInDays,
    int? commitCountLast30days,
    int? commitCountToday,
  }) {
    return GitInfoRecord(
      projectName: projectName ?? this.projectName,
      directoryPath: directoryPath ?? this.directoryPath,
      heatMapData: heatMapData ?? this.heatMapData,
      latestCommit: latestCommit ?? this.latestCommit,
      streakLength: streakLength ?? this.streakLength,
      timeRangeInDays: timeRangeInDays ?? this.timeRangeInDays,
      commitCountLast30days:
          commitCountLast30days ?? this.commitCountLast30days,
      commitCountToday: commitCountToday ?? this.commitCountToday,
    );
  }
}
