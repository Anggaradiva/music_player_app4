import 'package:flutter/material.dart';
import 'playlist_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlaylistScreen()),
            );
          },
          child: Text('Go to Playlists'),
        ),
      ),
    );
  }
}
