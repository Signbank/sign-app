import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnail extends StatefulWidget {
  final String url;

  const VideoThumbnail({super.key, required this.url});

  @override
  State<StatefulWidget> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController controller;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.url);

    initializeVideoPlayerFuture = controller.initialize();

    controller.setLooping(true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 ElevatedButton(
                     onPressed: () {
                       setState(() {
                         if (controller.value.isPlaying) {
                           controller.pause();
                         } else {
                           controller.play();
                         }
                       });
                     },
                     child: Icon(controller.value.isPlaying
                         ? Icons.pause
                         : Icons.play_arrow)),
                 ElevatedButton(
                     onPressed: () {
                       setState(() {
                         if (controller.value.playbackSpeed == 1) {
                           controller.setPlaybackSpeed(0.5);
                         } else {
                           controller.setPlaybackSpeed(1);
                         }
                       });
                     },
                     child: const Icon(Icons.slow_motion_video)),
               ],
              ),
            ]);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
