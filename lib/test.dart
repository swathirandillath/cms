import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


class ContentManagementApp extends StatefulWidget {
  @override
  State<ContentManagementApp> createState() => _ContentManagementAppState();
}

class _ContentManagementAppState extends State<ContentManagementApp> {
  final List<ContentItem> contentItems = [];
  final picker = ImagePicker();

  void _addTextItem() {
    setState(() {
      contentItems.add(ContentItem(type: 'text', content: 'New Text', x: 50, y: 50));
    });
  }

  Future<void> _addImageItem() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        contentItems.add(ContentItem(type: 'image', content: 'assets/sample.mp4', x: 50, y: 50));
      });
    }
  }

  Future<void> _addVideoItem() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        contentItems.add(ContentItem(type: 'video', content: pickedFile.path, x: 50, y: 50));
      });
    }
  }

  void _applyTemplate(int templateIndex) {
    setState(() {
      contentItems.clear();
      if (templateIndex == 1) {
        contentItems.addAll([
          ContentItem(type: 'text', content: 'Template Text', x: 100, y: 100),
          ContentItem(type: 'image', content: 'assets/sample.png', x: 50, y: 200),
        ]);
      } else if (templateIndex == 2) {
        contentItems.addAll([
          ContentItem(type: 'video', content: 'assets/sample.mp4', x: 0, y: 0),
          ContentItem(type: 'text', content: 'Template 2 Text', x: 150, y: 300),
        ]);
      }
    });
  }

  void _showPreview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(contentItems: contentItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Content Management App'),
        actions: [
          IconButton(icon: Icon(Icons.remove_red_eye), onPressed: _showPreview),
        ],
      ),
      body: Stack(
        children: contentItems.map((item) {
          return Positioned(
            left: item.x,
            top: item.y,
            child: Draggable(
              feedback: _buildItemWidget(item),
              child: _buildItemWidget(item),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                setState(() {
                  item.x = details.offset.dx;
                  item.y = details.offset.dy - AppBar().preferredSize.height;
                });
              },
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.text_fields), onPressed: _addTextItem),
            IconButton(icon: Icon(Icons.image), onPressed: _addImageItem),
            IconButton(icon: Icon(Icons.video_library), onPressed: _addVideoItem),
            PopupMenuButton<int>(
              icon: Icon(Icons.category),
              onSelected: _applyTemplate,
              itemBuilder: (context) => [
                PopupMenuItem(value: 1, child: Text('Template 1')),
                PopupMenuItem(value: 2, child: Text('Template 2')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemWidget(ContentItem item) {
    switch (item.type) {
      case 'text':
        return Container(
          color: Colors.amber,
          padding: EdgeInsets.all(8),
          child: Text(item.content, style: TextStyle(fontSize: 16)),
        );
      case 'image':
        return Image.asset(item.content, width: 100, height: 100, fit: BoxFit.cover);
      case 'video':
        return VideoPlayerWidget(videoPath: item.content);
      default:
        return Container();
    }
  }
}

// Content Item Model
class ContentItem {
  String type;
  String content;
  double x;
  double y;

  ContentItem({required this.type, required this.content, required this.x, required this.y});
}

// Video Player Widget
class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  VideoPlayerWidget({required this.videoPath});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
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
        ? SizedBox(width: 100, height: 100, child: VideoPlayer(_controller))
        : Container(
            width: 100,
            height: 100,
            color: Colors.black,
          );
  }
}

// Preview Screen
class PreviewScreen extends StatelessWidget {
  final List<ContentItem> contentItems;

  PreviewScreen({required this.contentItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview')),
      body: Stack(
        children: contentItems.map((item) {
          return Positioned(
            left: item.x,
            top: item.y,
            child: item.type == 'text'
                ? Text(item.content, style: TextStyle(fontSize: 20))
                : item.type == 'image'
                    ? Image.asset(item.content, width: 100, height: 100)
                    : VideoPlayerWidget(videoPath: item.content),
          );
        }).toList(),
      ),
    );
  }
}
