import 'dart:io';

Future<String> readFile(String filePath) async {
  try {
    final file = File(filePath);
    return await file.readAsString();
  } on Exception catch (e) {
    return e.toString();
  }
}

Future<String> writeFile(String filePath, String contents) async {
  try {
    final file = File(filePath);
    await file.writeAsString(contents);
    return 'ok';
  } on Exception catch (e) {
    return e.toString();
  }
}
