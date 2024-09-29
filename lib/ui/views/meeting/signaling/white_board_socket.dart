import 'dart:convert';
import 'dart:developer';

import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/views/meeting/model/hub_user_data/hub_user_data.dart';
import 'package:o_connect/ui/views/meeting/model/input.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class WhiteBoardSocket {
  WhiteBoardSocket({
    required this.url,
    this.onOpen,
    this.onClose,
    this.onDisconnected,
    this.onFailed,
  });

  /// Websocket URL.
  final String url;
  WhiteBoardSocket._({
    required this.url,
  });
  Function? onOpen;
  Function? onClose;
  Function? onDisconnected;
  Function? onFailed;
  Function(String method, dynamic data)? onRequest;
  Function(String method, dynamic data)? onNotification;

  static WhiteBoardSocket instance = WhiteBoardSocket._(url: BaseUrls.whiteBoardQaSocketUrl);

  /// [Socket] instance which will be used as communication channel between
  /// socket server and the app
  io.Socket? _socket;

  io.Socket? get socket => _socket;

  void init(HubSocketInput queryData, String token) {
    assert(token.isNotEmpty);
    log("White board init ${queryData.toMap()}");
    final optionBuilder = io.OptionBuilder()
        .setAuth({
          'token': token,
        })
        .setQuery(queryData.toMap())
        .disableAutoConnect()
        .setTransports(
          ['websocket', 'polling'],
        )
        .setExtraHeaders(
          {'Origin': BaseUrls.baseOriginUrl},
        );

    _socket = io.io(url, optionBuilder.build());

    // _socket?.on('open', (_) {
    //   log("White Board Socket Connected");
    // });
    // _socket?.on('failed', (data) {
    //   log("White Board Socket Failed");

    //   return onFailed?.call();
    // });
    // _socket?.on('disconnected', (_) {
    //   log("White Board Socket Failed");

    //   return onClose?.call();
    // });
    // _socket?.on('close', (_) {
    //   log("White Board Socket Close");
    //   return onClose?.call();
    // });

    _socket?.onAny((event, data) {
      log("on: $event, data: $data", name: 'WB SOCKET');
    });
  }

  void connect() => _socket?.connect();

  void close() => _socket?.close();
}

/// chat socket data model
