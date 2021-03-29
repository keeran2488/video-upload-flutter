import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';

class Dialogs {
  static Future<void> showUploading(BuildContext context, GlobalKey key,
      FlutterUploader uploader, String taskId) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            key: key,
            title: Text("Uploading your video"),
            content: Row(
              children: [
                CircularProgressIndicator(),
                Text("Please wait"),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await uploader.cancel(taskId: taskId);
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }
}
