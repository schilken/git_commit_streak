import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import '../components/settings_fields_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
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
            title: const Text('Settings'),
          ),
          children: [
            ContentArea(
              builder: (context, _) {
                return const Center(
                  child: SettingsFieldsView(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
