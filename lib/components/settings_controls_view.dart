// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

import 'package:git_commit_streak/utils/utils.dart';

import '../providers/notification_service.dart';
import '../providers/providers.dart';
import 'text_field_with_label.dart';

class SettingsControlsView extends ConsumerWidget {
  const SettingsControlsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifier);
    return SizedBox(
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 60,
          ),
          TextFieldWithLabel(
            label: 'Committer\'s Name to filter all Commits',
            placeholder: 'Enter Committer',
            initialValue: settings.committerName,
            onSubmitted: (value) =>
                ref.read(settingsNotifier.notifier).setCommitterName(value),
          ),
          gapHeight20,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Activate Reminders'),
              const Spacer(),
              MacosSwitch(
                value: settings.isReminderActive,
                onChanged: (value) {
                  ref.read(settingsNotifier.notifier).setReminderActive(value);
                },
              ),
            ],
          ),
          gapHeight20,
          if (settings.isReminderActive) ...[
            TextFieldWithLabel(
              label: 'Time to check the commit count',
              placeholder: 'Enter time as HH:MM',
              initialValue: settings.reminderHhMm,
              onSubmitted: (value) =>
                  ref.read(settingsNotifier.notifier).setReminderHhMm(value),
            ),
            gapHeight8,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Activate iMessage reminder'),
                const Spacer(),
                MacosSwitch(
                  value: settings.isSendIMessageActive,
                  onChanged: (value) {
                    ref
                        .read(settingsNotifier.notifier)
                        .setSendIMessageActive(value);
                  },
                ),
              ],
            ),
            if (settings.isSendIMessageActive) ...[
              gapHeight12,
              TextFieldWithLabel(
                label: 'Recipient of the iMessage',
                placeholder: 'Enter Recipient for iMessage',
                initialValue: settings.recipientName,
                onSubmitted: (value) =>
                    ref.read(settingsNotifier.notifier).setRecipientName(value),
              ),
            ],
            gapHeight12,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Notify Git Count'),
                const Spacer(),
                MacosSwitch(
                  value: settings.isApprovalActive,
                  onChanged: (value) {
                    ref
                        .read(settingsNotifier.notifier)
                        .setApprovalActive(value);
                  },
                ),
              ],
            ),
            PushButton(
              buttonSize: ButtonSize.large,
              isSecondary: true,
              onPressed: () async {
                await ref
                    .read(notificationServiceProvider)
                    .showNotification('Test Notification');
              },
              child: const Text('Test Notification'),
            ),
          ],
        ],
      ),
    );
  }
}

