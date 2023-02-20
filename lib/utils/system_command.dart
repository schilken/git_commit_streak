import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mixin_logger/mixin_logger.dart' as log;

class SystemCommand {
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
      log.w('stderr: ${process.stderr} $directory');
      return [];
    } else {
      final lines = process.stdout.split('\n');
      return lines;
    }
  }
}

final systemCommandProvider = Provider<SystemCommand>((ref) => SystemCommand());
