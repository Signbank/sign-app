import 'package:flutter/material.dart';
import 'package:sign_app/video_player.dart';

import 'ObjectClass/sign.dart';

class VideoPage extends StatefulWidget{
  const VideoPage({super.key, required this.sign});

  final Sign sign;

  @override
  State<StatefulWidget> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>{

  late String url;

  @override
  void initState(){
    super.initState();
    url = "https://signbank.cls.ru.nl/dictionary/protected_media/${widget.sign.videoUrl}";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sign.name),
      ),
      body: VideoThumbnail(url: url),
    );
  }
}