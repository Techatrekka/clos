import 'dart:async';
import 'dart:io';
import 'package:clos/utils/network.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';
import 'notifiers/repeat_button_notifier.dart';
import 'package:audio_service/audio_service.dart';
import 'services/playlist_repository.dart';
import 'services/service_locator.dart';

class PageManager {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  late Directory dir;
  final isTapeImageProvider = ValueNotifier<String>("/data/user/0/com.example.clos/app_flutter/5/image.png");

  late AudioHandler _audioHandler;
  late StreamSubscription<PlaybackState> playbackStateListener;
  late StreamSubscription<Duration> currentPostionListener;
  late StreamSubscription<Duration> savePositionListener;
  late StreamSubscription<PlaybackState> bufferedPositionListener;
  late StreamSubscription<MediaItem?> totalDurationListener;
  late StreamSubscription<MediaItem?> songChangesListener;


  // Events: Calls coming from the UI
  void init(String currentTape) async {
    _audioHandler = getIt<AudioHandler>();
    dir = await getApplicationDocumentsDirectory();
    await _loadPlaylist(currentTape);
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
    await _jumpToPreviousPoint();
    _getImage(currentTape);
  }

  Future<void> _getImage(String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File f = File("$dir/$filename/image.png");
    isTapeImageProvider.value = f.path;
  }

  Future<void> _loadPlaylist(String tapeId) async {
    final directory = await getApplicationDocumentsDirectory();
    var newDirectory = Directory("${directory.path}/$tapeId/");
    final songRepository = getIt<PlaylistRepository>();
    final numberOfFiles = newDirectory.listSync().length - 1;
    final playlist = await songRepository.fetchInitialPlaylist(newDirectory.path, numberOfFiles);
    final mediaItems = playlist
        .map((song) => MediaItem(
              id: song['id'] ?? '',
              album: song['album'] ?? '',
              title: song['title'] ?? '',
              extras: {'url': song['url']},
            ))
        .toList();
    _audioHandler.addQueueItems(mediaItems);
  }

  void _listenToPlaybackState() {
    playbackStateListener = _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    currentPostionListener = AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      print(1);
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
    bool mutex = false;
    savePositionListener = AudioService.position.listen((positionValue) {
      // this is the 15 second update listening history timer
      if (positionValue.inSeconds % 20 == 0 && !mutex && positionValue.inSeconds != 0) {
        mutex = true;
        uploadListeningHistory(1, 1, positionValue);
        sleep(Duration(seconds: 2));
        mutex = false;
      }
    });
  }

  Future<void> _jumpToPreviousPoint() async {
    var lh = await getListeningHistory("1","1");
    await _audioHandler.skipToQueueItem((lh.current_chapter-1));
    var timeToSkipTo = Duration(seconds: lh.chapter_progress);
    await _audioHandler.seek(timeToSkipTo);
  }

  void _listenToBufferedPosition() {
    bufferedPositionListener = _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    totalDurationListener = _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    songChangesListener = _audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void dispose() {
    _audioHandler.customAction("clear");
    _audioHandler.skipToQueueItem(0);
    playbackStateListener.cancel();
    currentPostionListener.cancel();
    savePositionListener.cancel();
    bufferedPositionListener.cancel();
    totalDurationListener.cancel();
    songChangesListener.cancel();
  }

  void stop() {
    _audioHandler.stop();
  }
}
