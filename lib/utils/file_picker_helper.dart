import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FilePickerHelper {
  static Future<List<File>> pickSongs() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.audio);
    if (result != null) {
      return result.paths.map((path) => File(path!)).toList();
    }
    return [];
  }
}
