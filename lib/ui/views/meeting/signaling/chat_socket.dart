import 'dart:developer';

import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../model/input.dart';

class ChatSocket {
  ChatSocket({
    required this.url,
    this.onOpen,
    this.onClose,
    this.onDisconnected,
    this.onFailed,
  });

  /// Websocket URL.
  final String url;

  Function? onOpen;
  Function? onClose;
  Function? onDisconnected;
  Function? onFailed;
  Function(String method, dynamic data)? onRequest;
  Function(String method, dynamic data)? onNotification;

  /// [Socket] instance which will be used as communication channel between
  /// socket server and the app
  io.Socket? _socket;

  io.Socket? get socket => _socket;

  void init(ChatSocketConnectionData chatData, String token) {
    assert(token.isNotEmpty);

    final optionBuilder = io.OptionBuilder().setAuth({'token': token}).setQuery(chatData.toMap()).disableAutoConnect().setTransports(['websocket']).setExtraHeaders(
          {
            'Origin': BaseUrls.baseOriginUrl,
          },
        );

    _socket = io.io(url, optionBuilder.build());

    _socket?.on('open', (_) => onOpen?.call());
    _socket?.on('failed', (data) => onFailed?.call());
    _socket?.on('disconnected', (_) => onClose?.call());
    _socket?.on('close', (_) => onClose?.call());

    _socket?.onAny((event, data) {
      log("event: $event, data: $data");
    });
  }

  void connect() => _socket?.connect();

  void close() => _socket?.close();
}
