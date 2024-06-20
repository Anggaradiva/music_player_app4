class Playlist {
  int id;
  String name;

  Playlist({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
