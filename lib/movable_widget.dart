import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MovableResizableInsideParent extends StatefulWidget {
  const MovableResizableInsideParent({super.key});

  @override
  _MovableResizableInsideParentState createState() => _MovableResizableInsideParentState();
}

class _MovableResizableInsideParentState extends State<MovableResizableInsideParent> {
  final double _parentWidth = 200.0, _parentHeight = 300.0;
  final List<MovableItem> _items = [];
  String _resizeDirection = '';
  int? _activeItemIndex;

  final ImagePicker _imagePicker = ImagePicker();

  void _addItem(String type) async {
    if (type == 'image') {
      final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      setState(() {
        _items.add(MovableItem(
          type: 'image',
          mediaPath: pickedFile.path,
          width: 100,
          height: 100,
          posX: 50,
          posY: 50,
        ));
        _activeItemIndex = _items.length - 1;
      });
    } else if (type == 'text') {
      setState(() {
        _items.add(MovableItem(
          type: 'text',
          width: 100,
          height: 100,
          posX: 50,
          posY: 50,
        ));
        _activeItemIndex = _items.length - 1;
      });
    } else if (type == 'video') {
      final XFile? pickedFile = await _imagePicker.pickVideo(source: ImageSource.gallery);
      if (pickedFile == null) return;
      setState(() {
        _items.add(MovableItem(
          type: 'video',
          mediaPath: pickedFile.path,
          width: 150,
          height: 150,
          posX: 50,
          posY: 50,
        ));
        _activeItemIndex = _items.length - 1;
      });
    }
  }

  void _onPanStart(DragStartDetails details, int index) {
    setState(() {
      final item = _items.removeAt(index);
      _items.add(item);
      _activeItemIndex = _items.length - 1;
    });

    final item = _items.last;
    final dx = details.localPosition.dx, dy = details.localPosition.dy;
    final isLeft = dx <= 20, isRight = dx >= item.width - 20;
    final isTop = dy <= 20, isBottom = dy >= item.height - 20;

    _resizeDirection = isLeft && isTop
        ? 'topLeft'
        : isRight && isTop
            ? 'topRight'
            : isLeft && isBottom
                ? 'bottomLeft'
                : isRight && isBottom
                    ? 'bottomRight'
                    : isLeft
                        ? 'left'
                        : isRight
                            ? 'right'
                            : isTop
                                ? 'top'
                                : isBottom
                                    ? 'bottom'
                                    : 'move';
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      if (_activeItemIndex == null) return;

      final item = _items[_activeItemIndex!];
      final dx = details.delta.dx, dy = details.delta.dy;

      if (_resizeDirection == 'move') {
        item.posX = (item.posX + dx).clamp(0.0, _parentWidth - item.width);
        item.posY = (item.posY + dy).clamp(0.0, _parentHeight - item.height);
      } else {
        if (_resizeDirection.contains('left') && item.posX + dx >= 0) {
          item.width = (item.width - dx).clamp(50.0, 500.0);
          item.posX += dx;
        }
        if (_resizeDirection.contains('right') && item.posX + item.width + dx <= _parentWidth) {
          item.width = (item.width + dx).clamp(50.0, 500.0);
        }
        if (_resizeDirection.contains('top') && item.posY + dy >= 0) {
          item.height = (item.height - dy).clamp(50.0, 500.0);
          item.posY += dy;
        }
        if (_resizeDirection.contains('bottom') && item.posY + item.height + dy <= _parentHeight) {
          item.height = (item.height + dy).clamp(50.0, 500.0);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resizable & Movable Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () => _addItem('text'),
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () => _addItem('image'),
          ),
          IconButton(
            icon: const Icon(Icons.video_library),
            onPressed: () => _addItem('video'),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: _parentWidth,
          height: _parentHeight,
          color: Colors.green,
          child: Stack(
            children: [
              for (int i = 0; i < _items.length; i++) _buildItem(_items[i], i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(MovableItem item, int index) {
    final bool isSelected = index == _activeItemIndex;

    return Positioned(
      left: item.posX,
      top: item.posY,
      child: GestureDetector(
        onPanStart: (details) => _onPanStart(details, index),
        onPanUpdate: _onPanUpdate,
        child: Stack(
          children: [
            Container(
              width: item.width,
              height: item.height,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.black,
                  width: isSelected ? 4 : 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: item.type == 'text'
                  ? const Center(
                      child: Text(
                        'Text',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : item.type == 'image'
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(item.mediaPath!),
                            fit: BoxFit.fill,
                          ),
                        )
                      : item.type == 'video'
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: VideoWidget(filePath: item.mediaPath!),
                            )
                          : const Icon(Icons.image, size: 50, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class MovableItem {
  String type;
  String? mediaPath;
  double width, height, posX, posY;

  MovableItem({
    required this.type,
    this.mediaPath,
    required this.width,
    required this.height,
    required this.posX,
    required this.posY,
  });
}

class VideoWidget extends StatefulWidget {
  final String filePath;
  const VideoWidget({required this.filePath, super.key});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
