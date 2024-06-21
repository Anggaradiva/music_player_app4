import 'package:flutter/material.dart';
import 'package:music_player_app4/services/playlist_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlaylistService _playlistService = PlaylistService();

  Future<void> _createPlaylist(String name) async {
    final playlist = {'name': name};
    await _playlistService.insertPlaylist(playlist); // Ganti createPlaylist dengan insertPlaylist
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final TextEditingController controller = TextEditingController();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Create Playlist'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(hintText: 'Playlist Name'),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Create'),
                          onPressed: () {
                            _createPlaylist(controller.text);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Create Playlist'),
            ),
          ],
        ),
      ),
    );
  }
}
