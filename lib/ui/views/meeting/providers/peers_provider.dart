import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';

import '../../../../dummy_json/home_json.dart';
import '../model/peer.dart';

class PeersProvider extends ChangeNotifier {
  // Map which holds peers in a meeting
  Map<String, Peer> _peers = {};

  // Unmodifiable getter for UI
  Iterable<Peer> get peers => UnmodifiableListView(_peers.values);

  Peer? getPeer(String id) => _peers[id];

  void addPeer(Map<String, dynamic> newPeer) {
    Peer peer = Peer.fromMap(newPeer);
    var countriesFlag = countries[peer.countryName];
    _peers[peer.id] = peer.copyWith(countryFlag: countriesFlag);
    notifyListeners();
  }

  void removePeer(String peerId) {
    final peer = _peers.remove(peerId);
    if (peer != null) {
      notifyListeners();
    }
  }

  void addConsumer(Consumer consumer, String peerId) async {
    var peer = _peers[peerId];

    if (peer != null) {
      print("DEBUG: SCREEN: ${peer.screen?.id}");
      print("DEBUG: VIDEO: ${peer.video?.id}");

      if (consumer.kind == 'video') {
        if (consumer.appData['source'] == 'screen') {
          peer = peer.copyWith(
            screen: () => consumer,
            screenRenderer: () => RTCVideoRenderer(),
          );
          await peer.screenRenderer?.initialize();
          peer.screenRenderer?.srcObject = consumer.stream;
        } else {
          peer = peer.copyWith(
            video: () => consumer,
            renderer: () => RTCVideoRenderer(),
          );
          await peer.renderer?.initialize();
          peer.renderer?.srcObject = consumer.stream;
        }

        print("TRACKS: ${consumer.stream.getTracks().length} ${consumer.stream.getVideoTracks().first.id}");
        print("VIDEO TRACKS: ${consumer.stream.getVideoTracks().length}");
        print("AUDIO TRACKS: ${consumer.stream.getAudioTracks().length}");
      } else if (consumer.kind == 'audio') {
        peer = peer.copyWith(audio: () => consumer);
      }

      _peers[peerId] = peer;
      notifyListeners();
    }
  }

  void pauseConsumer(String consumerId) {
    final Map<String, Peer> newPeers = Map<String, Peer>.of(_peers);
    final matchingPeers = newPeers.values.where((p) => p.consumers.contains(consumerId));
    if (matchingPeers.isEmpty) return;

    final peer = matchingPeers.first;

    if (peer.audio?.id == consumerId) {
      final consumer = peer.audio;
      _peers[peer.id] = peer.copyWith(audio: () => consumer?.pauseCopy(), isActiveSpeaker: false);
      notifyListeners();
    } else if (peer.video?.id == consumerId) {
      final consumer = peer.video;
      _peers[peer.id] = peer.copyWith(video: () => consumer?.pauseCopy());
      notifyListeners();
    }
  }

  void makeActiveSpeaker(String peerId) {
    final Map<String, Peer> newPeers = Map<String, Peer>.of(_peers);
    final matchingPeers = newPeers.values.where((p) => p.id == peerId);
    if (matchingPeers.isEmpty) return;

    final peer = matchingPeers.first;
    _peers[peer.id] = peer.copyWith(isActiveSpeaker: true);
    notifyListeners();
  }

  void resumeConsumer(String consumerId) {
    final Map<String, Peer> newPeers = Map<String, Peer>.of(_peers);
    final matchingPeers = newPeers.values.where((p) => p.consumers.contains(consumerId));
    if (matchingPeers.isEmpty) return;

    final peer = matchingPeers.first;

    if (peer.audio?.id == consumerId) {
      final consumer = peer.audio;
      _peers[peer.id] = peer.copyWith(audio: () => consumer?.resumeCopy(), isActiveSpeaker: true);
      notifyListeners();
    } else if (peer.video?.id == consumerId) {
      final consumer = peer.video;
      _peers[peer.id] = peer.copyWith(video: () => consumer?.resumeCopy());
      notifyListeners();
    } else if (peer.screen?.id == consumerId) {
      final consumer = peer.screen;
      _peers[peer.id] = peer.copyWith(screen: () => consumer?.resumeCopy());
      notifyListeners();
    }
  }

  void removeConsumer(String consumerId) async {
    final Map<String, Peer> newPeers = Map<String, Peer>.of(_peers);
    final matchingPeers = newPeers.values.where((p) => p.consumers.contains(consumerId));
    if (matchingPeers.isEmpty) return;

    final peer = matchingPeers.first;

    if (peer.audio?.id == consumerId) {
      final consumer = peer.audio;
      newPeers[peer.id] = newPeers[peer.id]!.removeAudio();
      _peers = newPeers;
      notifyListeners();

      // close the audio consumer
      await consumer?.close();
    } else if (peer.video?.id == consumerId) {
      final consumer = peer.video;
      final renderer = peer.renderer;
      newPeers[peer.id] = newPeers[peer.id]!.removeVideoAndRenderer();
      _peers = newPeers;
      notifyListeners();

      // close the consumer and dispose the renderer
      consumer?.close().then((_) => Future.delayed(const Duration(microseconds: 300))).then((_) async => await renderer?.dispose());
    } else if (peer.screen?.id == consumerId) {
      final consumer = peer.screen;
      final renderer = peer.screenRenderer;
      newPeers[peer.id] = newPeers[peer.id]!.removeScreenAndRenderer();
      _peers = newPeers;
      notifyListeners();

      // close the consumer and dispose the renderer
      consumer?.close().then((_) => Future.delayed(const Duration(microseconds: 300))).then((_) async => await renderer?.dispose());
    }
  }

  Future<void> close() async {
    for (var peer in _peers.values) {
      try {
        await peer.audio?.close();
        await peer.video?.close();
        await peer.screen?.close();
        await peer.renderer?.dispose();
        await peer.screenRenderer?.dispose();
      } catch (e) {
        debugPrint("");
      }
    }
    _peers.clear();
  }

  void toggleRaiseHand(String peerId, bool handRaised) {
    final p = peers.where((element) => element.id == peerId);
    if (p.isNotEmpty) {
      final Map<String, Peer> newPeers = Map<String, Peer>.of(_peers);
      newPeers[p.first.id] = newPeers[p.first.id]!.copyWith(raisedHand: handRaised);
      _peers = newPeers;
    }
    notifyListeners();
  }

  void updatePeerName(String peerId, String updatedName) {
    final Map<String, Peer> newPeers = Map<String, Peer>.of(_peers);
    newPeers[peerId] = newPeers[peerId]!.copyWith(displayName: updatedName);
    _peers = newPeers;
    notifyListeners();
  }

  void lowerHandForAll() {
    _peers.updateAll((key, value) => value.copyWith(raisedHand: false));
    notifyListeners();
  }
}
