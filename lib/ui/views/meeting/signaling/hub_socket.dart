import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class HubSocket {
  HubSocket._({
    required this.url,
  });

  static HubSocket instance = HubSocket._(url: BaseUrls.hubSocketUrl);

  /// Websocket URL.
  final String url;

  Function? onOpen;
  Function? onClose;
  Function? onFailed;
  Function(String method, dynamic data)? onRequest;
  Function(String method, dynamic data)? onNotification;

  /// [Socket] instance which will be used as communication channel between
  /// socket server and the app
  io.Socket? _socket;

  io.Socket? get socket => _socket;

  void init(HubSocketInput input, String token) {
    assert(token.isNotEmpty);

    if (socket != null && socket?.connected == true) {
      log("HUB SOCKET CLOSED");
      close();
    }

    final optionBuilder = io.OptionBuilder().setAuth({'token': token}).setQuery(input.toMap()).disableAutoConnect().setTransports(['websocket', 'polling']).setExtraHeaders(
          {
            'Origin': input.origin,
          },
        );

    _socket = io.io(url, optionBuilder.build());

    _socket?.onAny((event, data) {
      if (kDebugMode) {
        log("on: $event, $data", name: "HUB SOCKET");
      }
    });
    _socket?.on('open', (_) => onOpen?.call());
    _socket?.on('failed', (data) => onFailed?.call());

    _socket?.on("connect_timeout", (data) => {print("connect_timeout          ${data.toString()}")});
    _socket?.onDisconnect((data) => onClose?.call());
  }

  void connect() => _socket?.connect();
  void close() => _socket?.close();
}
