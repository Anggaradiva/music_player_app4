import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'db_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> _songs = [];
  bool _isPlaying = false;
  String _currentTitle = '';

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  void _loadSongs() async {
    var dbHelper = DBHelper();
    var songs = await dbHelper.getSongs();
    setState(() {
      _songs = songs;
    });
  }

  void _playSong(String title, String path) async {
    await _audioPlayer.play(DeviceFileSource(path));
    setState(() {
      _isPlaying = true;
      _currentTitle = title;
    });
  }

  void _importSong() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      var file = result.files.first;
      var dbHelper = DBHelper();
      await dbHelper.insertSong({
        'title': file.name,
        'path': file.path!,
      });
      _loadSongs();
      _playSong(file.name, file.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_songs[index]['title']),
                  onTap: () => _playSong(_songs[index]['title'], _songs[index]['path']),
                );
              },
            ),
          ),
          if (_isPlaying)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Now Playing: $_currentTitle'),
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () async {
                      await _audioPlayer.pause();
                      setState(() {
                        _isPlaying = false;
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _importSong,
        child: Icon(Icons.add),
      ),
    );
  }
}
