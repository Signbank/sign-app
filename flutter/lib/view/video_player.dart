import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final String url;
  final bool startPlaying;

  const VideoPlayerView(
      {super.key, required this.url, this.startPlaying = true});

  @override
  State<StatefulWidget> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController controller;
  late Future<void> initializeVideoPlayerFuture;

  double playbackSpeed = 1;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.url);

    initializeVideoPlayerFuture = controller.initialize();

    if (widget.startPlaying) {
      controller.play();
    }
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
            return Stack(children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  });
                },
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              ),
              Positioned(
                bottom: 0,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                    });
                  },
                  icon: Icon(
                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  iconSize: 38,
                ),
              ),
              Positioned(
                bottom: 5,
                right: 10,
                child: DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<double>(
                      value: playbackSpeed,
                      icon: const Icon(Icons.slow_motion_video),
                      items: <double>[0.25, 0.5, 0.75, 1].map((double value) {
                        return DropdownMenuItem<double>(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList(),
                      onChanged: (double? value) {
                        setState(() {
                          playbackSpeed = value!;
                          controller.setPlaybackSpeed(playbackSpeed);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ]);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

// ecoratedBox(
// decoration: BoxDecoration(
// color:Colors.lightGreen, //background color of dropdown button
// border: Border.all(color: Colors.black38, width:3), //border of dropdown button
// borderRadius: BorderRadius.circular(50), //border raiuds of dropdown button
// boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
// BoxShadow(
// color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
// blurRadius: 5) //blur radius of shadow
// ]
// ),
//
// child:Padding(
// padding: EdgeInsets.only(left:30, right:30),
