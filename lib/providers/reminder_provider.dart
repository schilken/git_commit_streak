// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mixin_logger/mixin_logger.dart' as log;

import 'cron_provider.dart';
import 'git_info_repository.dart';
import 'notification_service.dart';

class Reminder {
  Reminder(
    this.ref,
  ) : _reminderTicker = ref.watch(schedulerStreamProvider) {
    log.i('Reminder.constructor');
    _reminderTicker.listen((data) => checkCommitsOfToday());
    _gitInfoRepository = ref.read(gitInfoRepositoryProvider);
  }
  ProviderRef<Reminder> ref;
  final Stream<int> _reminderTicker;
  late GitInfoRepository _gitInfoRepository;

  checkCommitsOfToday() {
    log.i('checkCommitsOfToday');
    ref.read(notificationServiceProvider).showNotification('Test Notification');
  }
}

final reminderProvider = Provider<Reminder>((ref) {
  return Reminder(ref);
});
