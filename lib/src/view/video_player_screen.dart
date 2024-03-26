
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controller/movie_controller.dart';


class BasicPlayerPage extends StatefulWidget {
  BasicPlayerPage();

  @override
  State<BasicPlayerPage> createState() => _BasicPlayerPageState();

}

class _BasicPlayerPageState extends State<BasicPlayerPage> {
  MovieController  movieDetailsController = Get.find();


  // late TextEditingController _idController;
  //
  // late TextEditingController _seekToController;

  // late PlayerState _playerState;
  //
  // late YoutubeMetaData _videoMetaData;

  bool _isPlayerReady = false;



  @override
  void initState() {
    super.initState();
    movieDetailsController.playerController = YoutubePlayerController(
      initialVideoId: movieDetailsController.trailerKey,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    // _idController = TextEditingController();
    // _seekToController = TextEditingController();
    // _videoMetaData = const YoutubeMetaData();
    // _playerState = PlayerState.unknown;
  }

  void listener() {
    // if (_isPlayerReady && mounted && !movieDetailsController.playerController.value.isFullScreen) {
    //   // setState(() {
    //   //   _playerState = _controller.value.playerState;
    //   //   _videoMetaData = _controller.metadata;
    //   // });
    // }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    movieDetailsController.playerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    movieDetailsController.playerController.dispose();
    // _idController.dispose();
    // _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: movieDetailsController.playerController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        aspectRatio: 16 / 9,
        onReady: () {
          print("player Is ready now");
          _isPlayerReady = true;
        },
        onEnded: (data) {
          movieDetailsController.playTrailer.value = false;
          // _controller
          //     .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          // _showSnackBar('Next Video Started!');
        },
      ),
      builder: (context, player) => Scaffold(
        body: player,
      ),
    );
  }
}