import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:mixin_logger/mixin_logger.dart' as log;

import '../app_constants.dart';
import 'utils.dart';

typedef GitLogLines = List<String>;
typedef GitLogMap = Map<String, List<String>>;

class GitLogUtils {
  Future<List<String>> getGitLogForProject(String directoryPath) async {
    final parameters = [
      'log',
      '-n ${AppConstants.maxGitMessages}',
      '--pretty=%ci|%cn| %s',
    ];
    return await runShellCommand('git', parameters, directoryPath);
  }
}
