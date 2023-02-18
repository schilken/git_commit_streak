import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:git_commit_streak/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

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
      ],
    );
  }
}
