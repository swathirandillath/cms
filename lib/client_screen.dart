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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Client App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // QR code scanner button or scanner view
            serverUrl.isEmpty
                ? Column(
                    children: [
                      const Text(
                        'Scan QR Code from the Host App',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 100,
                        width: 200,
                        child: MobileScanner(
                          onDetect: (BarcodeCapture barcodeCapture) {
                            scanQRCode(barcodeCapture); // Handle the scanned QR code
                          },
                        ),
                      ),
                    ],
                  )
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
                          sendMessage(message);
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
