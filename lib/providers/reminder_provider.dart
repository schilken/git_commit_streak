// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mixin_logger/mixin_logger.dart' as log;

import 'providers.dart';

class Reminder {
  Reminder(
    this.ref,
  ) : _reminderTicker = ref.watch(cronServiceProvider).stream {
    log.i('Reminder.constructor');
    _reminderTicker.listen((data) => checkCommitsOfToday());
    _gitInfoRepository = ref.read(gitInfoRepositoryProvider);
    _preferencesRepository = ref.watch(preferencesRepositoryProvider);
  }
  ProviderRef<Reminder> ref;
  final Stream<int> _reminderTicker;
  late GitInfoRepository _gitInfoRepository;
  late PreferencesRepository _preferencesRepository;

  Future<void> checkCommitsOfToday() async {
    log.i('checkCommitsOfToday');
    final commitCount = await _gitInfoRepository.calcCommitCountOfToday(
      _preferencesRepository.currentDirectory,
      _preferencesRepository.committerName,
    );
    if (commitCount > 0) {
      await ref
          .read(notificationServiceProvider)
          .showNotification("Today's commit count: $commitCount");
      await ref.read(notificationServiceProvider).sendIMessage(
          "Today's commit count: $commitCount", 'alfred@schilken.de');
    } else {
      await ref
          .read(notificationServiceProvider)
          .showNotification('Not yet any commits today');
      await ref
          .read(notificationServiceProvider)
          .sendIMessage('Not yet any commits today', 'alfred@schilken.de');
    }
  }
}

final reminderProvider = Provider<Reminder>((ref) {
  return Reminder(ref);
});
