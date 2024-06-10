// This is a minimal example demonstrating a play/pause button and a seek bar.
// More advanced examples demonstrating other features can be found in the same
// directory as this example in the GitHub repository.

import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:clos/utils/common_functions.dart';
import 'package:clos/utils/models.dart';
import 'package:clos/widgets/custom_app_bar.dart';
import 'package:clos/widgets/library_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:clos/utils/audioplayer_common.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.audiobook});

  final AudioBook audiobook;

  @override
  PlayerScreenState createState() => PlayerScreenState();
}

class PlayerScreenState extends State<PlayerScreen> with WidgetsBindingObserver {
  final _player = AudioPlayer();
  late AudioBook _audioBook;

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _audioBook = widget.audiobook;
    _init();
  }

  Future<void> _init() async {
    final directory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory("${directory.path}/${_audioBook.id}/");
    var length = await newDirectory.list().length;
    var audioFiles = [];
    for (var i = 1; i < length; i++) {
      audioFiles.add("${newDirectory.path}/$i.mp3");
    }

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      var playlist = ConcatenatingAudioSource(
        children: []
      );
      for (int i = 0; i < audioFiles.length; i++) {
        playlist.add(AudioSource.file(audioFiles.elementAt(i)));
      }
      
      // var filepath = (await getDownloadsDirectory())!.absolute.path;
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
     // await _player.load();
      await _player.setAudioSource(
        // AudioSource.uri(Uri.parse(
        //  "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"
        // "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac"
        // ))
       // AudioSource.file(filepath + "/audio.mp3")
        // AudioSource.file(filepath + "/1/0001.mp3")
        playlist
          );
    } on PlayerException catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  Future<Image> _getImage() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Directory newdirectory = Directory("${directory.path}/1");
    print("directory contents");
    print(directory.listSync());
    print("directory contents");
    print(newdirectory.listSync());
    try {
      var getFolder = await getApplicationDocumentsDirectory();
      return Image.file(File("${getFolder.path}/1/image.png"));
    } catch (e) {
      return Image.asset("images/clos_logo.png");
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const CustomAppBar(title: "Title"),
        body: Container (
          color: Colors.black87,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TryGetImageFile(_audioBook.iconLocation),
                // Display play/pause button and volume/speed sliders.
                ControlButtons(_player),
                // Display seek bar. Using StreamBuilder, this widget rebuilds
                // each time the position, buffered position or duration changes.
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: _player.seek,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {super.key});

  void seekNext() async{
    await player.seekToNext();
  }

  void seekPrevious() async {
    await player.seekToPrevious();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: const Icon(Icons.volume_up),
          color: Colors.green,
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous),
          color: Colors.green,
          onPressed: seekPrevious,
        ),
        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                color: Colors.green,
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                color: Colors.green,
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                color: Colors.green,
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                color: Colors.green,
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          color: Colors.green,
          onPressed: seekNext,
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            color: Colors.green,
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}