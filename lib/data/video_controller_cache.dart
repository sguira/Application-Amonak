import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';

class VideoControllerCache {
  // Using a LinkedHashMap to keep track of the order of insertion,
  // which can be useful for implementing an LRU (Least Recently Used) cache.
  final Map<String, VideoPlayerController> _cache = {};
  final int _maxCacheSize =
      5; // Adjust this based on your memory considerations

  static final VideoControllerCache _instance =
      VideoControllerCache._internal();

  factory VideoControllerCache() {
    return _instance;
  }

  VideoControllerCache._internal();

  VideoPlayerController? getController(String videoId) {
    if (_cache.containsKey(videoId)) {
      // Move the accessed item to the end to signify it's recently used (LRU logic)
      final controller = _cache.remove(videoId)!;
      _cache[videoId] = controller;
      return controller;
    }
    return null;
  }

  void addController(String videoId, VideoPlayerController controller) {
    if (_cache.length >= _maxCacheSize) {
      // Remove the least recently used (first item in LinkedHashMap)
      _cache.remove(_cache.keys.first);
      if (kDebugMode) {
        print('Disposing least recently used controller: $_cache.keys.first');
      }
    }
    _cache[videoId] = controller;
  }

  void disposeController(String videoId) {
    final controller = _cache.remove(videoId);
    controller?.dispose();
    if (kDebugMode) {
      print('Explicitly disposed controller for videoId: $videoId');
    }
  }

  void clearCache() {
    _cache.forEach((key, controller) {
      controller.dispose();
    });
    _cache.clear();
    if (kDebugMode) {
      print('Video controller cache cleared.');
    }
  }
}
