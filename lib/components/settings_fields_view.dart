import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:git_commit_streak/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

import '../providers/notification_service.dart';
import '../providers/providers.dart';

class SettingsFieldsView extends ConsumerStatefulWidget {
  const SettingsFieldsView({super.key});

  @override
  _SettingsFieldsViewState createState() => _SettingsFieldsViewState();
}

class _SettingsFieldsViewState extends ConsumerState<SettingsFieldsView> {
  final _controller = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  dispose() {
    _focusNode.dispose();
    _controller.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus == false) {
      ref.read(settingsNotifier.notifier).setCommitterName(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = ref.watch(settingsNotifier).committerName;
    debugPrint('SettingsFieldsView build ${_controller.text}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Committer\'s Name to filter all Commits'),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          width: 300.0,
          child: MacosTextField(
            controller: _controller,
            focusNode: _focusNode,
            placeholder: 'Enter Committer',
            clearButtonMode: OverlayVisibilityMode.editing,
            maxLines: 1,
            onSubmitted: (value) =>
                ref.read(settingsNotifier.notifier).setCommitterName(value),
          ),
        ),
        gapHeight12,
        PushButton(
          buttonSize: ButtonSize.large,
          isSecondary: true,
          onPressed: () async {
            ref.read(notificationServiceProvider).init();
            ref.read(notificationServiceProvider).requestPermissions();
          },
          child: Text('Activate Notifications'),
        ),
        gapHeight8,
        PushButton(
          buttonSize: ButtonSize.large,
          isSecondary: true,
          onPressed: () async {
            await ref
                .read(notificationServiceProvider)
                .showNotification('Test Notification');
          },
          child: Text('Test Notification'),
        ),
      ],
    );
  }
}
