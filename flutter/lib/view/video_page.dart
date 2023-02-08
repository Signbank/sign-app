import 'package:flutter/material.dart';
import 'package:sign_app/app_config.dart';
import 'package:sign_app/models/sign.dart';
import 'package:sign_app/view/video_player.dart';

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
    url = Uri.https(signBankBaseMediaUrl, widget.sign.videoUrl).toString();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sign.name),
      ),
      body: VideoPlayerView(url: url),
    );
  }
}