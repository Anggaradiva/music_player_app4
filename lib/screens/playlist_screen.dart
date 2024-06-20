import 'package:flutter/material.dart';
import 'package:music_player_app4/services/playlist_service.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<Map<String, dynamic>> _playlists = [];

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    PlaylistService playlistService = PlaylistService();
    _playlists = await playlistService.getPlaylists();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
      ),
      body: ListView.builder(
        itemCount: _playlists.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_playlists[index]['name']),
          );
        },
      ),
    );
  }
}
