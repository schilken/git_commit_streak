import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

const _helpMarkdown = '''
# My Template for Git Commit Streak
This project is a stripped down skeleton which I use as a starting point for a new tool which either wraps a command clien tool or uses Dart, Flutter and packages to do something useful. 

## Some Hints about this Template App

- select a file type to search in in the sidebar
- select in the toolbar the folder to scan
- enter a search word in in the toolbar
- press enter or click the search icon to start the search

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
