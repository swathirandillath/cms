import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, required this.ontap});
  final Function ontap;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan to pair'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  print('inside on detect');
                  widget.ontap(barcodeCapture); // Handle the scanned QR code
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
