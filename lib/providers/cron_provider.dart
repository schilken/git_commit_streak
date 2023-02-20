import 'dart:async';

import 'package:cron/cron.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mixin_logger/mixin_logger.dart' as log;

final schedulerStreamProvider = Provider<Stream<int>>((ref) {
  log.i('scheduleStreamProvider');
  int id = 0;
  final cron = Cron();
  final streamController = StreamController<int>();
  final taskHandle = cron.schedule(Schedule.parse('*/1 * * * *'), () {
    log.i('cron task - ticked $id');
    streamController.add(id++);
  });
  ref.onDispose(() {
    streamController.close();
    taskHandle.cancel();
    log.i('scheduleStreamProvider disposed');
  });
  return streamController.stream;
});
