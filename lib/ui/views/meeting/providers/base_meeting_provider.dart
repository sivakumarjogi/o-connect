import 'dart:convert';
import 'dart:developer' as dev;

import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/replykit_channel.dart';
import 'package:o_connect/ui/utils/replykit_helper.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_data_response/data.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/meeting_room_repository.dart';
import '../signaling/hub_socket.dart';
import '../signaling/room_socket.dart';

abstract class BaseMeetingProvider extends BaseProvider with MeetingUtils {
  ReplayKitChannel replayKitChannel = ReplayKitChannel();

  final MeetingRoomRepository meetingRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.meetingBaseUrl,
  );

  final MeetingRoomRepository templateRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.templateBaseUrl,
  );

  final MeetingRoomRepository globalStatusRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.globalAccessStatusSetUrl,
  );

  final MeetingRoomRepository b18Repo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.panelCountUrl,
  );

  final HubSocket hubSocket = HubSocket.instance;

  final MeetingRoomWebsocket meetingSocket = MeetingRoomWebsocket.instance;

  // Current User device
  final Device localDevice = Device();

  // List of ICE servers, coming from room socket
  List<RTCIceServer> iceServers = [];

  // Transport which is used to produce our audio and video
  Transport? sendTransport;

  // Transport which is used to receive peers audio and video
  Transport? receiveTransport;

  Future<GenerateTokenUser> getUserData() async {
    final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");
    GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));

    return userData;
  }

  Future<MeetingGlobalAccessStatusResponse> fetchMeetingGlobalAccessStatus(
    String roomId,
  ) {
    final payload = {'roomId': roomId};
    return globalStatusRepo.fetchMeetingGlobalAccessStatus(payload);
  }

  Future<NewAttendeeResponse> addNewAttendee(
    GenerateTokenUser user,
    MeetingData meeting,
    String countryName,
    String userKey,
  ) async {
    // final payload = meeting.guestKey != userKey
    //     ? {
    //         "country": countryName,
    //         "user_id": user.id,
    //         "meeting_id": meeting.id,
    //         "meeting_name": meeting.meetingName,
    //         "user_name": user.userName,
    //         "email": user.userEmail,
    //         "is_organizer": user.id == meeting.userId ? true : false,
    //         "is_presenter": false,
    //         "is_speaker": true
    //       }
    //     : {
    //         "country": countryName,
    //         "user_id": user.id,
    //         "meeting_id": meeting.id,
    //         "meeting_name": meeting.meetingName,
    //         "user_name": user.userName,
    //         "email": user.userEmail,
    //         "is_organizer": false,
    //         "is_presenter": false,
    //         "is_speaker": false
    //       };

    final payload = {
      'country': countryName,
      'user_id': user.id,
      'meeting_id': meeting.id,
      'meeting_name': meeting.meetingName,
      'user_name': user.userName,
      'email': user.userEmail,
      'is_organizer': user.id == meeting.userId,
      'is_presenter': false,
      'is_speaker': meeting.guestKey == userKey ? false : true,
    };

    print("payloaddddddddddddddddddd   $payload");

    NewAttendeeResponse attendData = await templateRepo.addNewAttendee(payload);
    print("the attendee details are the ${attendData.data?.userId ?? "Nooo"} && ${attendData.data.toString()}");

    return attendData;
  }

  Future<MeetingDataResponse> fetchMeetingDetailsById(String id) async {
    Map<String, dynamic> payload = {"event_id": id};
    return meetingRepo.fetchEventDetailsById(payload);
  }

  Future<Iterable<int>> fetchPanelCount(String meetingId) async {
    try {
      final response = await b18Repo.fetchPanelCount(meetingId);
      if (response.data['status'] == true) {
        return (response.data['data'] as List<dynamic>).map((e) => int.parse(e['id'].toString())).toList();
      }
    } catch (e) {
      // dev.log(e.toString(), error: e, stackTrace: st);
    }
    return [];
  }

  Future<void> uploadGlobalAccessStatus(String roomId, DateTime meetingStartTime) async {
    try {
      // Enable Global Icons
      var body = {'key': 'enableGlobalIcons', 'roomId': roomId, 'value': true};
      await globalStatusRepo.updateGlobalAccessStatus(body);

      // Enable av mode
      body = {'key': 'isAvModeOn', 'roomId': roomId, 'value': 'av'};
      await globalStatusRepo.updateGlobalAccessStatus(body);

      // Update event status as event started
      body = {
        'key': 'eventStatus',
        'roomId': roomId,
        'value': {
          'status': 'EventStarted',
          'startTime': meetingStartTime.toUtc().toIso8601String(),
        }
      };
      await globalStatusRepo.updateGlobalAccessStatus(body);

      await meetingRepo.updateMeetingStatus({
        'is_started': 1,
        'meeting_id': roomId,
      });
    } catch (e, st) {
      dev.log(
        'Error while updating meeting status',
        error: e,
        stackTrace: st,
      );
    }
  }

  // Permissions
  Future<bool> checkVideoPermission() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted || status == PermissionStatus.limited;
  }

  Future<bool> checkAudioPermission() async {
    final status1 = await Permission.microphone.status;
    dev.log("audio permission: ${status1.toString()}");

    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted || status == PermissionStatus.limited;
  }

  // Mediasoup methods
  void setIceServers(res) {
    iceServers = (res['turnServers'] as List<dynamic>)
        .map(
          (e) => RTCIceServer(
            credentialType: RTCIceCredentialType.password,
            username: e['username'],
            credential: e['credential'],
            urls: (e['urls'] as List<dynamic>).map((e) => e.toString()).toList(),
          ),
        )
        .toList();
  }

  void getRouterCapabilities({
    required void Function() onSuccess,
  }) {
    meetingSocket.request('getRouterRtpCapabilities', '', (data) async {
      if (data != null && data is List && data.length > 1) {
        final routerRtpCapabilities = data[1];

        if (!localDevice.loaded) {
          final rtpCapabilities = RtpCapabilities.fromMap(routerRtpCapabilities);
          await localDevice.load(routerRtpCapabilities: rtpCapabilities);
        }

        onSuccess();
      }
    });
  }

  void createTransport({
    required bool producing,
    required Function? callback,
    required void Function() onSuccess,
  }) {
    meetingSocket.request('createWebRtcTransport', {
      "forceTcp": false,
      "producing": producing,
      "consuming": !producing,
      'sctpCapabilities': localDevice.sctpCapabilities.toMap(),
    }, (data) async {
      if (data != null && data is List && data.length > 1) {
        final transportParams = data[1];

        final transport = producing
            ? localDevice.createSendTransport(
                id: transportParams['id'],
                iceParameters: IceParameters.fromMap(transportParams['iceParameters']),
                iceCandidates: List<IceCandidate>.from(transportParams['iceCandidates'].map((iceCandidate) => IceCandidate.fromMap(iceCandidate)).toList()),
                dtlsParameters: DtlsParameters.fromMap(transportParams['dtlsParameters']),
                sctpParameters: transportParams['sctpParameters'] != null ? SctpParameters.fromMap(transportParams['sctpParameters']) : null,
                iceServers: iceServers,
                producerCallback: callback,
              )
            : localDevice.createRecvTransport(
                id: transportParams['id'],
                iceParameters: IceParameters.fromMap(transportParams['iceParameters']),
                iceCandidates: List<IceCandidate>.from(transportParams['iceCandidates'].map((iceCandidate) => IceCandidate.fromMap(iceCandidate)).toList()),
                dtlsParameters: DtlsParameters.fromMap(transportParams['dtlsParameters']),
                sctpParameters: transportParams['sctpParameters'] != null ? SctpParameters.fromMap(transportParams['sctpParameters']) : null,
                iceServers: iceServers,
                consumerCallback: callback,
              );

        if (producing) {
          sendTransport = transport;
        } else {
          receiveTransport = transport;
        }

        transport.on('connect', (data) async {
          try {
            final info = {'transportId': transport.id, 'dtlsParameters': data['dtlsParameters'].toMap()};
            meetingSocket.request(
              'connectWebRtcTransport',
              info,
              data['callback'],
            );
            dev.log("CONNECT WEBRTC TRANSPORT");
          } catch (e, st) {
            dev.log('on connect()', error: e, stackTrace: st);
          }
        });

        if (producing) {
          transport.on('produce', (data) async {
            try {
              print("PRODUCE CALLED");
              final info = {
                'transportId': transport.id,
                'kind': data['kind'],
                'rtpParameters': data['rtpParameters'].toMap(),
                if (data['appData'] != null) 'appData': Map<String, dynamic>.from(data['appData'])
              };

              meetingSocket.request(
                'produce',
                info,
                (res) {
                  print("produce() result: $res");
                  data['callback'](res[1]['id']);
                },
              );
            } catch (e, st) {
              dev.log('on produce()', error: e, stackTrace: st);
            }
          });

          transport.on('producedata', (data) async {
            try {
              final info = {
                'transportId': transport.id,
                'sctpStreamParameters': data['sctpStreamParameters'].toMap(),
                'label': data['label'],
                'protocol': data['protocol'],
                'appData': data['appData'],
              };
              meetingSocket.request('produceData', info, (data) {
                // TODO(appal): find out if we are using produceData
                // data['callback'](data['id']);
              });
            } catch (error) {
              data['errback'](error);
            }
          });
        }

        onSuccess();
      }
    });
  }

  Future<MediaStream?> produceVideo(String deviceId) async {
    Map<String, dynamic> mediaConstraints = <String, dynamic>{
      'video': {
        'mandatory': {
          'minWidth': '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        // uncomment below lines to get video stream from specific video source
        // 'optional': [
        //   {
        //     'sourceId': deviceId,
        //   },
        // ],
      }
    };
    print("media ===>$mediaConstraints");
    MediaStream? videoStream;

    try {
      if (!localDevice.canProduce(RTCRtpMediaType.RTCRtpMediaTypeVideo)) {
        dev.log('ERROR: CAN NOT PRODUCE VIDEO');
        return null;
      }

      videoStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      final MediaStreamTrack track = videoStream.getVideoTracks().first;

      const videoVPVersion = kIsWeb ? 9 : 8;
      RtpCodecCapability? codec = localDevice.rtpCapabilities.codecs.firstWhere(
        (RtpCodecCapability c) => c.mimeType.toLowerCase() == 'video/vp$videoVPVersion',
        orElse: () => throw 'desired vp$videoVPVersion codec+configuration is not supported',
      );
      sendTransport?.produce(
        track: track,
        stream: videoStream,
        codecOptions: ProducerCodecOptions(
          videoGoogleStartBitrate: 1000,
        ),
        codec: codec,
        source: 'webcam',
        appData: {
          'source': 'webcam',
        },
      );
    } catch (e) {
      videoStream?.dispose();
    }
    return videoStream;
  }

  Future<MediaStream?> produceLocalVideoRenderTest(String deviceId) async {
    Map<String, dynamic> mediaConstraints = <String, dynamic>{
      'video': {
        'mandatory': {
          'minWidth': '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        // uncomment below lines to get video stream from specific video source
        // 'optional': [
        //   {
        //     'sourceId': deviceId,
        //   },
        // ],
      }
    };
    print("media ===>$mediaConstraints");
    MediaStream? videoStream;

    try {
      if (!localDevice.canProduce(RTCRtpMediaType.RTCRtpMediaTypeVideo)) {
        dev.log('ERROR: CAN NOT PRODUCE VIDEO');
        return null;
      }

      videoStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      final MediaStreamTrack track = videoStream.getVideoTracks().first;

      const videoVPVersion = kIsWeb ? 9 : 8;
      RtpCodecCapability? codec = localDevice.rtpCapabilities.codecs.firstWhere(
        (RtpCodecCapability c) => c.mimeType.toLowerCase() == 'video/vp$videoVPVersion',
        orElse: () => throw 'desired vp$videoVPVersion codec+configuration is not supported',
      );
      sendTransport?.produce(
        track: track,
        stream: videoStream,
        codecOptions: ProducerCodecOptions(
          videoGoogleStartBitrate: 1000,
        ),
        codec: codec,
        source: 'webcam',
        appData: {
          'source': 'webcam',
        },
      );
    } catch (e, st) {
      print("the error while producing video $e && $st");
      videoStream?.dispose();
    }
    return videoStream;
  }

  Future<void> startScreenSharingIos() async {
    ReplayKitHelper().openReplayKit();
    replayKitChannel.startReplayKit();
    replayKitChannel.listenEvents(context: navigationKey.currentContext!);
  }

  Future<bool?> presentScreen() async {
    initForegroundTask() async {
      FlutterForegroundTask.init(
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'oconnect_meeting',
          channelName: 'OConnect Meeting Notification',
          channelDescription: 'Notification channel for oconnect meetings',
          channelImportance: NotificationChannelImportance.HIGH,
          priority: NotificationPriority.HIGH,
          iconData: const NotificationIconData(
            resType: ResourceType.mipmap,
            resPrefix: ResourcePrefix.ic,
            name: 'launcher',
          ),
        ),
        iosNotificationOptions: const IOSNotificationOptions(
          showNotification: true,
          playSound: false,
        ),
        foregroundTaskOptions: const ForegroundTaskOptions(
          interval: 5000,
          isOnceEvent: false,
          autoRunOnBoot: true,
          allowWakeLock: true,
          allowWifiLock: true,
        ),
      );
    }

    await initForegroundTask();

    if (WebRTC.platformIsAndroid) {
      // Android specific
      Future<void> requestBackgroundPermission([bool isRetry = false]) async {
        // Required for android screenshare.
        try {
          await FlutterForegroundTask.startService(
            notificationText: "You are presenting",
            notificationTitle: "Screenshare is in progress.",
          );
        } catch (e) {
          if (!isRetry) {
            return await Future<void>.delayed(const Duration(seconds: 1), () => requestBackgroundPermission(true));
          }
          print('could not publish video: $e');
        }
      }

      await requestBackgroundPermission();
    }

    Map<String, dynamic> mediaConstraints = {
      'video': true,
    };
    if (WebRTC.platformIsIOS) {
      mediaConstraints['video'] = {'deviceId': 'broadcast'};
    }

    MediaStream? videoStream;

    try {
      videoStream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);

      videoStream.onAddTrack = (track) {
        print("Here it is added ${track.toString()}");
        track.onEnded = () {
          print("Here track is ended");
        };
      };
      videoStream.onRemoveTrack = (track) {
        print("Here it is removed ${track.toString()}");
        track.onEnded = () {
          print("Here track is ended");
        };
      };

      final List<MediaStreamTrack> tracks = videoStream.getVideoTracks();

      // const videoVPVersion = kIsWeb ? 9 : 8;
      // RtpCodecCapability? codec = localDevice.rtpCapabilities.codecs.firstWhere(
      //   (RtpCodecCapability c) => c.mimeType.toLowerCase() == 'video/vp$videoVPVersion',
      //   orElse: () => throw 'desired vp$videoVPVersion codec+configuration is not supported',
      // );

      tracks.first.onEnded = () {
        print("Screen share ended here");
        print(tracks.first.enabled);
      };
      sendTransport?.produce(
        track: tracks.first,
        stream: videoStream,
        // codecOptions: ProducerCodecOptions(
        //   videoGoogleStartBitrate: 1000,
        // ),
        // codec: codec,
        source: 'screen',
        appData: {
          'source': 'screen',
        },
      );
      return true;
    } catch (e, st) {
      dev.log('screenshareToggle:', error: e, stackTrace: st, name: 'MEETING');

      videoStream?.dispose();
      await FlutterForegroundTask.stopService();

      CustomToast.showErrorToast(msg: 'Unable to start screenshare');
    }
    return false;
  }

  Future<void> produceAudio(String deviceId) async {
    Map<String, dynamic> mediaConstraints = {
      'audio': {
        'optional': [
          {
            'sourceId': deviceId,
          },
        ],
      },
    };

    MediaStream? audioStream;
    try {
      audioStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      final track = audioStream.getAudioTracks().first;
      sendTransport?.produce(
        track: track,
        stream: audioStream,
        codecOptions: ProducerCodecOptions(opusStereo: 1, opusDtx: 1),
        source: 'mic',
        appData: {
          'source': 'mic',
        },
      );
    } catch (e) {
      audioStream?.dispose();
    }
  }
}
