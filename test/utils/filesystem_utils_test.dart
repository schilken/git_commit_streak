import 'package:flutter_test/flutter_test.dart';
import 'package:git_commit_streak/utils/filesystem_utils.dart';

void main() {
  testWidgets('filesystem startWithUsersFolder', (tester) async {
    final sut = FilesystemUtils();
    const fullPathName =
        '/Volumes/Macintosh HD/Users/aschilken/flutterdev/my_projects';
    final result = sut.startWithUsersFolder(fullPathName);
    expect(result, '/Users/aschilken/flutterdev/my_projects');
  });
}
