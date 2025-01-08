import 'package:content_managment_app_test/anvas_page.dart';
import 'package:flutter/material.dart';

class ScreenSelectionPage extends StatelessWidget {
  final Map<String, Size> screenSizes = {
    'A4': const Size(595, 842),
    'A3': const Size(842, 1191),
    'A3L': const Size(1191, 842),
    'D16': const Size(1024, 768),
  };

   ScreenSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Screen Size')),
      body: ListView.builder(
        itemCount: screenSizes.keys.length,
        itemBuilder: (context, index) {
          String key = screenSizes.keys.elementAt(index);
          return ListTile(
            title: Text(key),
            subtitle: Text('Width: ${screenSizes[key]!.width}, Height: ${screenSizes[key]!.height}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CanvasPage(
                    screenSize: screenSizes[key]!,
                    screenName: key,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
