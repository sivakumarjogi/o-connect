import 'dart:developer' as dev;

import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class MeetingRoomWebsocket {
  MeetingRoomWebsocket._({
    required this.url,
  });

  /// Websocket URL.
  final String url;

  Function? onOpen;
  Function? onClose;
  Function? onConnected;
  Function? onDisconnected;
  Function? onFailed;
  Function? onConnectError;
  Function(String method, dynamic data)? onRequest;
  Function(String method, dynamic data)? onNotification;

  static MeetingRoomWebsocket instance = MeetingRoomWebsocket._(url: BaseUrls.meetingRoomSocketUrl);

  /// [Socket] instance which will be used as communication channel between
  /// socket server and the app
  io.Socket? _socket;

  io.Socket? get socket => _socket;

  void initialize(Map<String, dynamic> input) {
    final optionBuilder = io.OptionBuilder().setQuery(input).disableAutoConnect().setTransports(['websocket', 'polling']).setExtraHeaders(
      {
        'Origin': input['origin'],
      },
    );

    _socket = io.io(url, optionBuilder.build());

    _socket?.onAny((event, data) {
      dev.log("on: $event data: $data", name: "ROOM SOCKET");
    });

    _socket?.on('open', (_) => onOpen?.call());
    _socket?.on('failed', (_) => onFailed?.call());
    _socket?.on('disconnected', (_) => onClose?.call());
    _socket?.on('close', (_) => onClose?.call());
    _socket?.on('connect_error', (data) => onConnectError?.call());
    _socket?.onConnect((data) => onConnected?.call());
    _socket?.on(
      'notification',
      (data) => onNotification?.call(data['method'], data['data']),
    );
  }

  void request(String method, dynamic data, [Function? ack]) => _socket?.emitWithAck(
        'request',
        {
          'method': method,
          'data': data,
        },
        ack: ack,
      );
  void connect() => _socket?.connect();
  void close() => _socket?.close();
}
