import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload/file_provider.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    File file = Provider.of<FileModel>(context, listen: true).file;
    _controller = VideoPlayerController.file(file)
      ..initialize().then((value) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: 4 / 5,
              child: VideoPlayer(_controller),
            )
          : Container(),
    );
  }
}
