import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

const _helpMarkdown = r'''
# Git Commit Streak

A tool that shows the number of consecutive days with at least one commit per day 

## How To Use

- **First:** In the settings enter your name as it is used by git. The git logs are filtered by this name.
- Click **Choose Folder** in the dropdown menu in the toolbar. 
- In the file selector find the directory to scan for all contained git repositories.
- Configure in the settings, whether you want to get a reminder each day.
  - Enter the time you want to get a notification on your Mac.
  - If you can receive iMessages, you can **Activate iMessage Reminder**.
  - You will get the reminder __*Not yet any commits today*__ if no commits are found for today. 
  - If you also want to get the commit count, activate the last switch on the settings page. 
  Then you will get a notification like __*Today's commit count: 3*__.
  - You can test the configuration with the button **Test Notification**

## Disable the Standby Mode
The app can only check the commits at the specified time, when the Mac is **not** powered off and the app is running. 
By default, a new Mac is–at least in Europe–configured to power down after some delay being in sleep mode (**standby 1**).

For example: I use this app to remind me at 19:00, when I haven't committed anything yet. 
And that shall work also when the MacBook is closed. 
With the **pmset -c** command, I disable the auto-power-off. The parameter **-c** means, deactivate it only when the Mac is connected to the power grid.
So I won't get reminders when the MacBook runs on battery, and don't drain the battery more than necessary.
Use **man pmset** in the terminal or Google to look up other options, for example **-a**.

``` 
$ sudo pmset -c standby 0
<enter root password>

$ pmset -g
System-wide power settings:
Currently in use:
 standby              0
...
```

''';

class HelpPage extends ConsumerWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MacosScaffold(
      toolBar: ToolBar(
        leading: MacosIconButton(
          icon: const MacosIcon(
            CupertinoIcons.sidebar_left,
            size: 40,
            color: CupertinoColors.black,
          ),
          onPressed: () {
            MacosWindowScope.of(context).toggleSidebar();
          },
        ),
        title: const Text('Help Page'),
      ),
      children: [
        ContentArea(
          minWidth: 500,
          builder: (context, scrollController) {
            return Markdown(
              //            controller: controller,
              data: _helpMarkdown,
              selectable: true,
              styleSheet: MarkdownStyleSheet().copyWith(
                h1Padding: const EdgeInsets.only(top: 12, bottom: 4),
                h1: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                h2Padding: const EdgeInsets.only(top: 12, bottom: 4),
                h2: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                p: const TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
