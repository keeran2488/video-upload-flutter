import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FileModel with ChangeNotifier {
  File _file;
  File get file => _file;

  imageSelect() async {
    FilePickerResult pickedFile =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (pickedFile != null) {
      // PlatformFile file = pickedFile.files.first;
      _file = File(pickedFile.files.single.path);
      notifyListeners();
      // print("size:" + file.size.toString());
    }
  }

  set image(File file) {
    _file = file;
    notifyListeners();
  }
}
