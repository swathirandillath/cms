import 'dart:io';

import 'package:content_managment_app_test/draggable_item.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CanvasPage extends StatefulWidget {
  final Size screenSize;
  final String screenName;

 const CanvasPage({super.key, required this.screenSize, required this.screenName});

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  List<Widget> contentWidgets = [];
  final ImagePicker _picker = ImagePicker();

void _addContent(String type) async {
  XFile? pickedFile;

  if (type == 'image') {
    pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  } else if (type == 'video') {
    pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
  } else {
    return;
  }

  if (pickedFile != null) {
    setState(() {
      contentWidgets.add(
        Positioned(
          left: 50,
          top: 50,
          child: ResizableDraggableItem(
            type: type,
            filePath: pickedFile!.path,
          ),
        ),
      );
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.screenName} Canvas')),
      body: Center(
        child: Container(
          width: widget.screenSize.width,
          height: widget.screenSize.height,
          color: Colors.grey.shade200,
          child: Stack(
            children: contentWidgets,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddContentDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddContentDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Add Image'),
              onTap: () {
                _addContent('image');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Add Text'),
              onTap: () {
                _addContent('text');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Add Video'),
              onTap: () {
                _addContent('video');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
