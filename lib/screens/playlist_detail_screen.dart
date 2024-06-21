import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:music_player_app4/services/playlist_service.dart';
import 'music_player_screen.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final int playlistId;
  final String playlistName;

  const PlaylistDetailScreen({Key? key, required this.playlistId, required this.playlistName}) : super(key: key);

  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  List<Map<String, dynamic>> _songs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    PlaylistService playlistService = PlaylistService();
    _songs = await playlistService.getSongs(widget.playlistId);
    setState(() {});
  }

  Future<void> _addSongs() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      PlaylistService playlistService = PlaylistService();
      for (var file in result.files) {
        await playlistService.insertSong({
          'playlistId': widget.playlistId,
          'title': file.name,
          'path': file.path,
        });
      }
      _loadSongs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addSongs,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_songs[index]['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayerScreen(song: _songs[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
