// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

import 'package:git_commit_streak/utils/utils.dart';

import '../providers/notification_service.dart';
import '../providers/providers.dart';
import 'switch_with_label.dart';
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
          SwitchWithLabel(
            label: 'Activate Reminders',
            initialValue: settings.isReminderActive,
            onChanged: ref.read(settingsNotifier.notifier).setReminderActive,
          ),
          gapHeight20,
          if (settings.isReminderActive) ...[
            TextFieldWithLabel(
              label: 'Time to check the commit count',
              placeholder: 'Enter time as HH:MM',
              initialValue: settings.reminderHhMm,
              onSubmitted: (value) =>
                  ref.read(settingsNotifier.notifier).setReminderHhMm(value),
              regexValidator: '^[012][0-9]:[0-5][0-9]\$',
            ),
            gapHeight8,
            SwitchWithLabel(
              label: 'Activate iMessage reminder',
              initialValue: settings.isSendIMessageActive,
              onChanged:
                  ref.read(settingsNotifier.notifier).setSendIMessageActive,
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
            SwitchWithLabel(
              label: 'Notify also the current Commit Count',
              initialValue: settings.isApprovalActive,
              onChanged: ref.read(settingsNotifier.notifier).setApprovalActive,
            ),
            gapHeight4,
            Container(
              padding: EdgeInsets.all(4),
              color: Colors.grey.shade200,
              child: Text(
                  'Also send an iMessage if there are commits today. As a small reward.'),
            ),
            gapHeight20,
            Row(
              children: [
                PushButton(
                  buttonSize: ButtonSize.small,
                  isSecondary: true,
                  color: Colors.grey.shade100,
                  onPressed: () async {
                    await ref.read(settingsNotifier.notifier).validate();
                  },
                  child: const Text('Validate Settings'),
                ),
                gapWidth4,
                Text(settings.validationMessage),
                Spacer(),
                if (settings.validationMessage.length < 4)
                  PushButton(
                    buttonSize: ButtonSize.small,
                    isSecondary: true,
                    color: Colors.grey.shade100,
                    onPressed: () async {
                      await ref
                          .read(notificationServiceProvider)
                          .showNotification('Test Notification');
                    },
                    child: const Text('Test Notification'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

