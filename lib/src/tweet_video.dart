import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:tweet_ui/models/viewmodels/tweet_vm.dart';
import 'package:video_player/video_player.dart';

// TODO add option to choose if the video should be opened in a new window or in this widget.
// TODO make TweetGif and don't show the play/pause buttons, autoplay ON, no gesture detector, no progresbar
class TweetVideo extends StatefulWidget {
  TweetVideo(
    this.tweetVM, {
    Key key,
  }) : super(key: key);

  final TweetVM tweetVM;

  @override
  _TweetVideoState createState() => _TweetVideoState();
}

class _TweetVideoState extends State<TweetVideo> with AutomaticKeepAliveClientMixin {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.tweetVM.videoUrl);
    _controller.setVolume(0.0);

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      showControls: !widget.tweetVM.hasGif,
      allowedScreenSleep: false,
      autoInitialize: true,
      allowFullScreen: false,
      allowMuting: !widget.tweetVM.hasGif,
      autoPlay: widget.tweetVM.hasGif,
      looping: widget.tweetVM.hasGif,
      overlay: Padding(
        padding: const EdgeInsets.only(
          left: 4.0,
        ),
        child: widget.tweetVM.hasGif
            ? Align(
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  "assets/tw__ic_gif_badge.png",
                  fit: BoxFit.fitWidth,
                  package: 'tweet_ui',
                  height: 16,
                  width: 16,
                ),
              )
            : Container(),
      ),
      aspectRatio: widget.tweetVM.videoAspectRatio,
    );
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Chewie(controller: _chewieController);
  }

  @override
  bool get wantKeepAlive => true;
}
