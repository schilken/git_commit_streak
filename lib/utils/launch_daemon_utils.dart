import 'dart:io';

class LaunchDaemonUtils {
  LaunchDaemonUtils({
    required this.bundleId,
    required this.appPath,
  });

  final String bundleId;
  final String appPath;

  File get _plistFile => File(
      '${Platform.environment['HOME']}/Library/LaunchAgents/$bundleId.plist');

  bool isEnabled() {
    return _plistFile.existsSync();
  }

  bool enable(int hour, int minute) {
    String contents = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>$bundleId</string>
    <key>ProgramArguments</key>
    <array>
      <string>$appPath</string>
    </array>
    <key>StartCalendarInterval</key>
<dict>
  <key>Hour</key>
  <integer>$hour</integer>
  <key>Minute</key>
  <integer>$minute</integer>
</dict>  

  </dict>
</plist>
''';
    if (!_plistFile.parent.existsSync()) {
      _plistFile.parent.createSync(recursive: true);
    }
    _plistFile.writeAsStringSync(contents);
    return true;
  }

  bool disable() {
    if (_plistFile.existsSync()) {
      _plistFile.deleteSync();
    }
    return true;
  }
}
