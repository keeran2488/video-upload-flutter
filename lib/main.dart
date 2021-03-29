import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:upload/file_provider.dart';
import 'package:upload/upload.dart';
import 'package:upload/video_app.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'dialog.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FileModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter File Upload Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter file upload example"),
      ),
      body: Center(
        child: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<State> _keyProgress = new GlobalKey<State>();
  File file;
  final uploader = FlutterUploader();

  checkNetwork(BuildContext context) async {}

  uploadImage(BuildContext context) async {
    Text content;
    file = Provider.of<FileModel>(context, listen: false).file;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        final String savedDir = dirname(file.path);
        final String filename = basename(file.path);
        String url = "http://192.168.1.212:8000/upload/";
        // var request = new http.MultipartRequest("POST", url);
        // print(request);
        // request.fields['name'] = fileName;
        // request.files.add(
        //   await http.MultipartFile.fromPath(
        //     'image',
        //     file.path,
        //     filename: fileName,
        //     // contentType: MediaType.Video,
        //   ),
        // );
        var fileItem = FileItem(
          filename: filename,
          savedDir: savedDir,
          fieldname: 'image',
        );
        final taskId = await uploader.enqueue(
          url: url,
          files: [fileItem],
          data: {"name": filename},
          method: UploadMethod.POST,
          tag: "upload 1",
          showNotification: true,
        );
        Dialogs.showUploading(context, _keyProgress, uploader, taskId);

        uploader.result.listen((result) {
          Navigator.of(_keyProgress.currentContext, rootNavigator: true).pop();
          final snackBar = SnackBar(
            content: Text("Uploaded!"),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }, onError: (ex, stacktrace) {
          print("exception: $ex");
          if (ex.status.toString() == "UploadTaskStatus(5)") {
            content = Text("Upload cancelled!");
          } else {
            Navigator.of(_keyProgress.currentContext, rootNavigator: true)
                .pop();
            content = Text("Something went wrong.");
          }
          print("stacktrace: $stacktrace" ?? "no stacktrace");
          final snackBar = SnackBar(
            content: content,
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        // var response = await request.send();
        // if (response.statusCode == 201) {
        //   print('Uploaded!');
        //   Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        // } else {
        //   print('Error!');
        // }
      }
    } on SocketException catch (_) {
      final snackBar = SnackBar(
        content: Text("Please check your internet connection!"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (_) {
      final snackBar = SnackBar(
        content: Text("Please select a video!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<FileModel>().imageSelect();
              },
              child: Text("Select Video"),
            ),
            context.watch<FileModel>().file == null
                ? SizedBox(
                    height: 10,
                  )
                : VideoApp(),
            OutlinedButton(
              onPressed: () => uploadImage(context),
              // onPressed: () => checkNetwork(context),
              child: Text("Upload Video"),
            ),
            Text("File: ${context.watch<FileModel>().file}"),
          ],
        ),
      ),
    );
  }
}
