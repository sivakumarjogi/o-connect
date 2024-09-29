import 'dart:async';
import 'dart:developer';

import 'package:events2/events2.dart';
import 'package:mediasoup_client_flutter/src/common/logger.dart';

Logger _logger = Logger('EnhancedEventEmitter');

class EnhancedEventEmitter extends EventEmitter {
  EnhancedEventEmitter() : super();
  void safeEmit(String event, [Map<String, dynamic>? args]) {
    try {
      emit(event, args);
    } catch (error) {
      _logger.error(
        'safeEmit() event listener threw an error [event:$event]:$error',
      );
    }
  }

  Future<dynamic> safeEmitAsFuture(String event, [Map<String, dynamic>? args]) async {

    try {
      final Completer<dynamic> completer = Completer<dynamic>();
      Map<String, dynamic> _args = {
        'callback': completer.complete,
        'errback': completer.completeError,
        ...?args,
      };
      emitAsFuture(event, _args);
      return completer.future;
    } on Exception catch (e,st) {
      log("exception: ", error: e, stackTrace: st);
    } catch (error) {
      _logger.error(
        'safeEmitAsFuture() event listener threw an error [event:$event]:$error',
      );
    }
  }
}
