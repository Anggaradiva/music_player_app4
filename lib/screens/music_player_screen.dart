import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> song;

  const MusicPlayerScreen({Key? key, required this.song}) : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  Future<void> _play() async {
    await _audioPlayer.play(DeviceFileSource(widget.song['path']));
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song['title']),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            isPlaying ? Icons.music_note : Icons.music_off,
            size: 100,
          ),
          SizedBox(height: 20),
          Text(widget.song['title'], style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 64,
                onPressed: _play,
              ),
              IconButton(
                icon: Icon(Icons.pause),
                iconSize: 64,
                onPressed: _pause,
              ),
              IconButton(
                icon: Icon(Icons.stop),
                iconSize: 64,
                onPressed: _stop,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
