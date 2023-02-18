import 'dart:io';
import 'package:mixin_logger/mixin_logger.dart' as log;

Future<List<String>> runShellCommand(
  executable,
  arguments,
  String directory,
) async {
  final process = await Process.run(
    executable,
    arguments,
    workingDirectory: directory,
  );
  if (process.exitCode != 0) {
    log.w('stderr: ${process.stderr}');
    return [];
  } else {
    final lines = process.stdout.split('\n');
    return lines;
  }
}
