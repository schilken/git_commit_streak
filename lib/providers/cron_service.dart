import 'dart:async';

import 'package:cron/cron.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mixin_logger/mixin_logger.dart' as log;

class CronService {
  Cron? _cron;
  StreamController<int>? _streamController;
  ScheduledTask? _taskHandle;
  int id = 0;
  Stream<int> get stream {
    if (_streamController == null) {
      log.w('CronService stream not yet initialized');
      init();
    }
    return _streamController!.stream;
  }

  void init() {
    if (_cron == null) {
      log.i('CronService init');
      _streamController = StreamController<int>();
      _cron = Cron();
    }
  }

  void dispose() {
    _taskHandle?.cancel();
    _streamController?.close();
    log.i('CronService disposed');
  }

  void cancel() {
    _taskHandle?.cancel();
  }

  void schedule(String atHhMm) async {
    init();
    log.i('CronService.schedule $atHhMm');
    final parts = atHhMm.split(':');
    if (parts.length != 2) {
      log.e('CronService wrong formatted argument atHhMm: $atHhMm');
      return;
    }
    final hour = int.parse(parts.first);
    final minute = int.parse(parts.last);
    await _taskHandle?.cancel();
    _taskHandle = _cron!.schedule(Schedule.parse('$minute $hour * * *'), () {
      log.i('CronService - ticked $id');
      _streamController!.add(id++);
    });
  }
}

final cronServiceProvider = Provider<CronService>((ref) {
  return CronService();
});
