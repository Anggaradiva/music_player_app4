import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  String currentSongPath = '';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  Future<void> _playMusic(String path) async {
    if (isPlaying) {
      await _audioPlayer.stop();
    }
    Source audioSource = DeviceFileSource(path);  // Mengonversi String ke Source
    await _audioPlayer.play(audioSource);
    setState(() {
      currentSongPath = path;
      isPlaying = true;
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      String path = result.files.single.path!;
      _playMusic(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (currentSongPath.isNotEmpty)
            Text('Playing: $currentSongPath'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Pick and Play Music'),
          ),
          SizedBox(height: 20),
          if (isPlaying)
            ElevatedButton(
              onPressed: () async {
                await _audioPlayer.stop();
                setState(() {
                  isPlaying = false;
                  currentSongPath = '';
                });
              },
              child: Text('Stop Music'),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
