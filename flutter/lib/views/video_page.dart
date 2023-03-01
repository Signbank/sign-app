import 'package:flutter/material.dart';
import 'package:sign_app/url_config.dart';
import 'package:sign_app/models/sign.dart';
import 'package:sign_app/views/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key, required this.sign, this.isAddingSign});

  final Sign sign;
  final isAddingSign;

  @override
  State<StatefulWidget> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late String url;

  @override
  void initState() {
    super.initState();
    url = signBankBaseMediaUrl + widget.sign.videoUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sign.name),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        VideoPlayerView(url: url),
        Visibility(
          visible: widget.isAddingSign == null ? false : true,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    //TODO: find better way to return data then removing two screens
                    widget.isAddingSign.addSign(widget.sign);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Add sign to quiz")),
            ),
          ),
        )
      ]),
    );
  }
}
