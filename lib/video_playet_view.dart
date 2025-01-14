
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// /// A widget that displays a video player using a provided URL.
// ///
// /// This widget uses the `video_player` and `chewie` packages to handle
// /// video playback. The `VideoPlayerView` takes a URL as input, initializes
// /// the video player controller, and uses `ChewieController` for additional
// /// functionality and controls.
// ///
// /// The `url` parameter must be a valid video URL that the `video_player`
// /// package can interpret and play.
// class VideoPlayerView extends StatefulWidget {
//   ///
//   const VideoPlayerView({
//     required this.url,
//     super.key,
//   });

//   /// The URL of the video to play.
//   final String url;

//   @override
//   State<VideoPlayerView> createState() => _VideoPlayerViewState();
// }

// class _VideoPlayerViewState extends State<VideoPlayerView> {
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize the video player controller with the provided network URL.
//     _videoPlayerController =
//         VideoPlayerController.networkUrl(Uri.parse(widget.url));

//     // Initialize the video player and set up the Chewie controller when ready.
//     _videoPlayerController.initialize().then(
//       (_) {
//         if (mounted) {
//           setState(() {
//             _chewieController = ChewieController(
//               allowPlaybackSpeedChanging: false,
//               showOptions: false,
//               allowFullScreen: false,
//               allowMuting: false,
//               videoPlayerController: _videoPlayerController,
//               aspectRatio: 16 / 9,
//             );
//           });
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     // Dispose of the video player and Chewie controllers to free up resources.
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Display the Chewie player if the controller is initialized, otherwise show a loading indicator.
//         if (_chewieController != null)
//           AspectRatio(
//             aspectRatio: 16 / 9,
//             child: Chewie(
//               controller: _chewieController!,
//             ),
//           ),
//       ],
//     );
//   }
// }
