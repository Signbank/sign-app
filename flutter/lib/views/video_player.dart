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
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  double _playbackSpeed = 1;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = _controller.initialize();

    if (widget.startPlaying) {
      _controller.play();
    }
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3.5,
      width: double.infinity,
      child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return InkWell(
              onTap: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(children: [
                  VideoPlayer(_controller),
                  Positioned(
                    bottom: 0,
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        });
                      },
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      color: Colors.black,
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
                          value: _playbackSpeed,
                          icon: const Icon(Icons.slow_motion_video),
                          items: <double>[0.25, 0.5, 0.75, 1]
                              .map((double value) {
                            return DropdownMenuItem<double>(
                              value: value,
                              child: Text('$value'),
                            );
                          }).toList(),
                          onChanged: (double? value) {
                            setState(() {
                              _playbackSpeed = value!;
                              _controller.setPlaybackSpeed(_playbackSpeed);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            );
          }),
    );
  }
}
