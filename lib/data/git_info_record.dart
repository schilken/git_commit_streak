// ignore_for_file: public_member_api_docs, sort_constructors_first
class GitInfoRecord {
  final String projectName;
  final String directoryPath;
  final List<String> commitMessages;
  final Map<DateTime, int> heatMapData;
  final DateTime latestCommit;
  final int streakLength;
  final int timeRangeInDays;
  final int commitCountLast30days;

  GitInfoRecord({
    required this.projectName,
    required this.directoryPath,
    this.commitMessages = const [],
    this.heatMapData = const {},
    required this.latestCommit,
    required this.streakLength,
    required this.timeRangeInDays,
    required this.commitCountLast30days,
  });

  int get totalCommitCount => heatMapData.values.isEmpty
      ? commitMessages.length
      : heatMapData.values.reduce((sum, val) => sum + val);

  GitInfoRecord copyWith({
    String? title,
    String? directoryPathName,
    List<String>? commitMessages,
    Map<DateTime, int>? heatMapData,
    DateTime? latestCommit,
    int? streakLength,
    int? timeRangeInDays,
    int? commitCountLast30days,
  }) {
    return GitInfoRecord(
      projectName: title ?? this.projectName,
      directoryPath: directoryPathName ?? this.directoryPath,
      commitMessages: commitMessages ?? this.commitMessages,
      heatMapData: heatMapData ?? this.heatMapData,
      latestCommit: latestCommit ?? this.latestCommit,
      streakLength: streakLength ?? this.streakLength,
      timeRangeInDays: timeRangeInDays ?? this.timeRangeInDays,
      commitCountLast30days:
          commitCountLast30days ?? this.commitCountLast30days,
    );
  }
}
