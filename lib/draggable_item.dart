import 'dart:io';

import 'package:content_managment_app_test/custom_matri.dart';
import 'package:content_managment_app_test/video_playet_view.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class ResizableDraggableItem extends StatefulWidget {
  final String type;
  final String filePath;

  const ResizableDraggableItem({
    super.key,
    required this.type,
    required this.filePath,
  });

  @override
  State<ResizableDraggableItem> createState() => _ResizableDraggableItemState();
}

class _ResizableDraggableItemState extends State<ResizableDraggableItem> {
  Matrix4 matrix = Matrix4.identity();

  Widget _getContent() {
    switch (widget.type) {
      case 'image':
        return Image.file(
          File(widget.filePath),
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        );
      case 'video':
        return Container(
          width: 150,
          height: 150,
          color: Colors.black,
          child: Center(
            child: VideoPlayerView(
              url: widget.filePath,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomMatrixDetector(
      onMatrixUpdate: (updatedMatrix, _, __, ___) {
        setState(() {
          matrix = updatedMatrix;
        });
      },
      shouldTranslate: true,
      shouldScale: true,
      shouldRotate: true,
      child: Transform(
        transform: matrix,
        child: _getContent(),
      ),
    );
  }
}
