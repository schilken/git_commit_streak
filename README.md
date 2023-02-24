# git_commit_streak

A tool that shows how many days there are uninterrupted commits

This is a second tool made from a starter project created by mason using macosui_tool_starter.

It scans all git repositories below the selected directory and reads the git log to collect all commits done in last 240 days. From this data a "heatmap" and the commit streak is created. The heatmap is a color coded calendar. The darker the green color the more changes were committed on that day. The streak is the number of sonsecutive days with at least one commit per day.

## Getting Started

Create your own version if you have Flutter installed on macOS anyway.

```
git clone github.com/schilken/git_commit_streak
flutter pub get
flutter build macos
```
You find the built app here: `git_commit_streak/build/macos/Build/Products/Release/GitCommitStreak`

<img src="assets_for_readme/GitCommitStreak-Screenshot.png"/>

## Download a release from GitHub
Currrently there is only a release build for [macOS] (https://github.com/schilken/git_commit_streak/releases/)

## Making of this app or similar tools
I generated a starter project using mason. If you want to create a similar tool you can generate a starter project like so:
- Open https://brickhub.dev
- Search for macosui_tool_starter
- Follow the steps on the Usage page

## Don't forget to extend the entitlements on macOS
Often the tools require access to the file system or provide an HTTP server. 
So in such a case, update the plist dictionary in the files DebugProfile.entitlements and Release.entitlements in the macos/Runner directory.
For example: 
```
<dict>
	<key>com.apple.security.app-sandbox</key>
	<false/>
	<key>com.apple.security.cs.allow-jit</key>
	<true/>
	<key>com.apple.security.files.downloads.read-write</key>
	<true/>
	<key>com.apple.security.files.user-selected.read-write</key>
	<true/>
	<key>com.apple.security.network.server</key>
	<true/>
</dict>
```

## Credits
Several ideas are taken from https://github.com/bizz84/complete-flutter-course, a great source for learning advanced Flutter created by Andrea Bizzotto (bizz84). Also, thanks to Reuben Turner (GroovinChip) for his great package at https://github.com/GroovinChip/macos_ui
