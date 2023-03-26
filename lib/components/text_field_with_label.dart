import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import '../utils/app_sizes.dart';
import '../utils/typedefs.dart';

class TextFieldWithLabel extends StatefulWidget {
  const TextFieldWithLabel({
    super.key,
    required this.label,
    required this.placeholder,
    required this.initialValue,
    required this.onSubmitted,
    this.regexValidator,
  });

  final String label;
  final String placeholder;
  final String initialValue;
  final StringCallback onSubmitted;
  final String? regexValidator;

  @override
  State<TextFieldWithLabel> createState() => _TextFieldWithLabelState();
}

class _TextFieldWithLabelState extends State<TextFieldWithLabel> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    _controller.text = widget.initialValue;
    super.initState();
    _focusNode.addListener(() => submitIfValid(_controller.text, context));
  }

  void submitIfValid(
    String value,
    BuildContext context,
  ) {
    if (_focusNode.hasFocus) {
      return;
    }
    if (widget.regexValidator != null) {
      final regex = RegExp(widget.regexValidator!);
      if (regex.hasMatch(value)) {
        widget.onSubmitted(value);
      } else {
        _controller.text = '';
        widget.onSubmitted('');
        Future<void>.delayed(
            const Duration(milliseconds: 10),
            () => showMacosAlertDialog(
                  context: context,
                  builder: (context) => MacosAlertDialog(
                    appIcon: const MacosIcon(
                      CupertinoIcons.exclamationmark_triangle,
                      size: 32,
                      color: Colors.orangeAccent,
                    ),
                    title: const Text(
                      'Input is not valid',
                    ),
                    message: Text(
                      'Please, ${widget.placeholder}',
                    ),
                    //horizontalActions: false,
                    primaryButton: PushButton(
                      buttonSize: ButtonSize.large,
                      onPressed: Navigator.of(context).pop,
                      child: const Text('OK'),
                    ),
                  ),
          ),
        );
      }
    } else {
      widget.onSubmitted(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(color: Colors.blueGrey)),
        gapHeight8,
        SizedBox(
          width: 200,
          child: MacosTextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.all(0),
            autocorrect: false,
            enableSuggestions: false,
            placeholder: widget.placeholder,
//            placeholderStyle: TextStyle(color: Colors.red),
            clearButtonMode: OverlayVisibilityMode.editing,
            onSubmitted: widget.onSubmitted,
          ),
        ),
      ],
    );
  }
}
