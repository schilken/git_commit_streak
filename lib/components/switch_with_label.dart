import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import '../utils/typedefs.dart';

class SwitchWithLabel extends StatelessWidget {
  const SwitchWithLabel({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  final String label;
  final bool initialValue;
  final BoolCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
//      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        const Spacer(),
        MacosSwitch(
          value: initialValue,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
