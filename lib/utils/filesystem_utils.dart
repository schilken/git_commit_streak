import 'dart:io';

import 'package:mixin_logger/mixin_logger.dart' as log;
import 'package:path/path.dart' as p;

class FilesystemUtils {
  Future<String?> readFile(String filePath) async {
    try {
      final file = File(filePath);
      return await file.readAsString();
    } on Exception catch (e) {
      log.w('readFile $e');
      return null;
    }
  }

  Future<String> writeFile(String filePath, String contents) async {
    try {
      final file = File(filePath);
      await file.writeAsString(contents);
      return 'ok';
    } on Exception catch (e) {
      log.w('writeFile $e');
      return e.toString();
    }
  }

  String startWithUsersFolder(String fullPathName) {
    final parts = p.split(fullPathName);
    if (parts.length > 3 && parts[3] == 'Users') {
      return '/${p.joinAll(parts.sublist(3))}';
    }
    return fullPathName;
  }
}
