import 'dart:convert';

import 'package:content_managment_app_test/movable_widget.dart';
import 'package:content_managment_app_test/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  late WebSocketChannel channel;
  String message = '';
  String serverUrl = ''; // Store the WebSocket server URL

  // Function to connect to the WebSocket server
  void connectToServer(String url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
    channel.stream.listen((message) {
      setState(() {
        this.message = message;
      });
    });

    //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientScreen()));
  }

  // Handle QR code scan
  void scanQRCode(BarcodeCapture barcodeCapture) {
    final qrCode = barcodeCapture.barcodes.first.rawValue;
    if (qrCode != null && qrCode.isNotEmpty) {
      setState(() {
        serverUrl = qrCode;
      });
      connectToServer(serverUrl); // Connect to the WebSocket server
    }
  }

  // Function to send a message to the WebSocket server
  void sendMessage(String message) {
    if (message.isNotEmpty) {
      channel.sink.add(message);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void sendStackedWidget() {
    // Example stacked items (you can dynamically create this)
    final stackedItems = [
      StackedItem(x: 50, y: 50, width: 100, height: 100, color: '0xFF0000FF'), // Blue
      StackedItem(x: 100, y: 150, width: 120, height: 120, color: '0xFFFF0000'), // Red
    ];

    // Serialize the list of items to JSON
    final jsonList = stackedItems.map((item) => item.toJson()).toList();
    final jsonString = jsonEncode(jsonList);

    // Send the JSON string through the WebSocket channel
    channel.sink.add(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScanScreen(
                            ontap: (barcodeCapture) {
                              scanQRCode(barcodeCapture);
                            },
                          )));
            },
            child: const Center(child: Text('Scan'))),
      ),
      appBar: AppBar(title: const Text('Client App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MovableResizableInsideParent(
                                onTap: (jsonString) {
                                  setState(() {
                                    channel.sink.add(jsonString);
                                  });
                                },
                              )));
                },
                child: const Text('Create Program')),
            // QR code scanner button or scanner view
            serverUrl.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      Text(
                        'Connected to: $serverUrl',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      // Send message button
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            message = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Enter message to send',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          sendStackedWidget();
                        },
                        child: const Text('Send Message'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Received message: $message',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class StackedItem {
  final double x;
  final double y;
  final double width;
  final double height;
  final String color; // Hexadecimal color code

  StackedItem({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.color,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'color': color,
    };
  }

  // Create from JSON
  factory StackedItem.fromJson(Map<String, dynamic> json) {
    return StackedItem(
      x: json['x'],
      y: json['y'],
      width: json['width'],
      height: json['height'],
      color: json['color'],
    );
  }
}
