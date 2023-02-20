// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mixin_logger/mixin_logger.dart' as log;

import 'cron_provider.dart';
import 'git_info_repository.dart';
import 'notification_service.dart';
import 'preferences_repository.dart';

class Reminder {
  Reminder(
    this.ref,
  ) : _reminderTicker = ref.watch(schedulerStreamProvider) {
    log.i('Reminder.constructor');
    _reminderTicker.listen((data) => checkCommitsOfToday());
    _gitInfoRepository = ref.read(gitInfoRepositoryProvider);
    _preferencesRepository = ref.watch(preferencesRepositoryProvider);
  }
  ProviderRef<Reminder> ref;
  final Stream<int> _reminderTicker;
  late GitInfoRepository _gitInfoRepository;
  late PreferencesRepository _preferencesRepository;

  checkCommitsOfToday() async {
    log.i('checkCommitsOfToday');
    final commitCount = await _gitInfoRepository.calcCommitCountOfToday(
      _preferencesRepository.currentDirectory,
      _preferencesRepository.committerName,
    );
    if (commitCount > 0) {
      ref
          .read(notificationServiceProvider)
          .showNotification("Today's commit count: $commitCount");
    } else {
      ref
          .read(notificationServiceProvider)
          .showNotification('Not yet any commits today');
    }
  }
}

final reminderProvider = Provider<Reminder>((ref) {
  return Reminder(ref);
});
