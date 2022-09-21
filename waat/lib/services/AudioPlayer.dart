import 'dart:async';

import 'package:just_audio/just_audio.dart' as JustAudio;

class AudioPlayer {
  final JustAudio.AudioPlayer player;

  AudioPlayer(
    this.player,
  );

  StreamSubscription<JustAudio.PlayerState> _playerStateStreamSubscription;
  StreamController<bool> _loadingStreamController;

  void dispose() {
    player.dispose();
    _playerStateStreamSubscription?.cancel();
    _loadingStreamController?.close();
  }
  //
  // Future<void> playFromFile(String fileName, {bool preload = true}) async {
  //   final appDirectory = await getApplicationDocumentsDirectory();
  //   String pathToFile = 'file://${appDirectory.path}/$fileName';
  //
  //
  //   await _play(
  //     setResource: () => player.setUrl(pathToFile, preload: preload),
  //   );
  // }

  Future<void> playFromUrl(String url, {bool preload = true}) async {
    await _play(
      setResource: () => player.setUrl(url, preload: preload),
    );
  }

  Future<void> stop() async {
    await player.pause();
    await player.seek(Duration.zero);
    _playerStateStreamSubscription?.cancel();
    _playerStateStreamSubscription = null;
  }

  Stream<bool> get isPlayingStream {
    return player.playingStream;
  }

  Stream<Duration> get positionStream {
    return player.positionStream;
  }

  // streams values between 0.0 and 1.0 indicating current playing progress
  Stream<double> get playingProgressStream async* {
    await for (final currentPosition in positionStream) {
      if (currentPosition == Duration.zero) {
        yield 0.0;
      } else {
        final duration = player.duration ?? Duration.zero;
        yield 1 / (duration.inMilliseconds / currentPosition.inMilliseconds);
      }
    }
  }

  Stream<bool> get isLoadingStream {
    _loadingStreamController = StreamController<bool>(
      onListen: () => print('AudioPlayer listen'),
      onCancel: () => print('AudioPlayer cancel'),
    );

    return _loadingStreamController.stream;
  }

  Future<void> _play({
    Future<void> Function() setResource,
  }) async {
    _playerStateStreamSubscription = player.playerStateStream.listen(
      _handlePlayerStateStreamEvent,
    );

    await setResource();
    await player.play();
  }

  void _handlePlayerStateStreamEvent(JustAudio.PlayerState playerState) {
    var isLoading = playerState.processingState == JustAudio.ProcessingState.loading;
    _loadingStreamController?.add(isLoading);

    if (playerState.processingState == JustAudio.ProcessingState.completed) stop();
  }
}
