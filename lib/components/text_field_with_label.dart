import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:macos_ui/macos_ui.dart';

import '../utils/app_sizes.dart';
import '../utils/typedefs.dart';

class TextFieldWithLabel extends HookWidget {
  const TextFieldWithLabel({
    super.key,
    required this.label,
    required this.placeholder,
    required this.initialValue,
    required this.onSubmitted,
  });

  final String label;
  final String placeholder;
  final String initialValue;
  final StringCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialValue);
    final focusNode = useFocusNode()
      ..addListener(() => onSubmitted(controller.text));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.blueGrey)),
        gapHeight8,
        SizedBox(
          width: 200,
          child: MacosTextField(
            controller: controller,
            focusNode: focusNode,
            decoration: const BoxDecoration(),
            placeholder: placeholder,
            clearButtonMode: OverlayVisibilityMode.editing,
            maxLines: 1,
            onSubmitted: onSubmitted,
          ),
        ),
      ],
    );
  }
}
