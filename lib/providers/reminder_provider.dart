// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mixin_logger/mixin_logger.dart' as log;

import 'cron_provider.dart';

class Reminder {
  Reminder(
    this.ref,
  ) : _reminderTicker = ref.watch(schedulerStreamProvider) {
    log.i('Reminder.constructor');
    _reminderTicker.listen((data) => checkCommitsOfToday());
  }
  ProviderRef<Reminder> ref;
  final Stream<int> _reminderTicker;

  checkCommitsOfToday() {
    log.i('checkCommitsOfToday');
  }

}

final reminderProvider = Provider<Reminder>((ref) {
  return Reminder(ref);
});
