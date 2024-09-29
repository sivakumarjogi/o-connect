import 'package:flutter/foundation.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';

class MediaDevicesProvider extends ChangeNotifier {
  List<MediaDeviceInfo> audioInput = [];
  List<MediaDeviceInfo> audioOutput = [];
  List<MediaDeviceInfo> videoInput = [];

  MediaDeviceInfo? selectedAudioDevice;
  MediaDeviceInfo? selectedVideoDevice;

  MediaDevicesProvider() {
    navigator.mediaDevices.ondevicechange = (data) {
      print("MEDIA DEVICES STATE CHANGED");
      // TODO(appal): what happens if audio/video device is disconnected
      enumerateDevices();
    };
  }

  Future<void> enumerateDevices() async {
    final devices = await navigator.mediaDevices.enumerateDevices();

    for (var device in devices) {
      if (device.kind == 'videoinput') {
        videoInput.add(device);
      } else if (device.kind == 'audioinput') {
        audioInput.add(device);
      } else if (device.kind == 'audiooutput') {
        audioOutput.add(device);
      }
    }

    selectedAudioDevice ??= audioInput.first;
    final frontCameras = videoInput.where((d) => d.label.toLowerCase().contains('front'));

    if (frontCameras.isNotEmpty) {
      selectedVideoDevice = frontCameras.first;
    } else if (videoInput.isNotEmpty) {
      selectedVideoDevice = videoInput.first;
    }
  }

  void setSelectedAudioDevice(String id) {
    assert(id.isNotEmpty);
    final devices = audioInput.where((element) => element.deviceId == id);
    if (devices.isNotEmpty) {
      selectedAudioDevice = devices.first;
      notifyListeners();
    }
  }

  void setSelectedVideoDevice(String id) {
    assert(id.isNotEmpty);
    final devices = videoInput.where((element) => element.deviceId == id);
    if (devices.isNotEmpty) {
      selectedVideoDevice = devices.first;
      notifyListeners();
    }
  }

  void resetState() {
    audioInput.clear();
    videoInput.clear();
    audioOutput.clear();
  }
}
