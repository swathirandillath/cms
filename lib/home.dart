import 'package:content_managment_app_test/custom_matri.dart';
import 'package:flutter/material.dart';

class MatrixDemo extends StatefulWidget {
  @override
  State<MatrixDemo> createState() => _MatrixDemoState();
}

class _MatrixDemoState extends State<MatrixDemo> {
  Matrix4 matrix = Matrix4.identity(); // This is where the matrix is defined and updated

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Matrix Detector Demo")),
      body: Center(
        child: CustomMatrixDetector(
          onMatrixUpdate: (Matrix4 updatedMatrix, Matrix4 translationDeltaMatrix, Matrix4 scaleDeltaMatrix, Matrix4 rotationDeltaMatrix) {
            // Use the updated matrix values here (for example, log them)
            print("Matrix: $matrix");
            print("Translation: $translationDeltaMatrix");
            print("Scale: $scaleDeltaMatrix");
            print("Rotation: $rotationDeltaMatrix");
            setState(() {
              matrix = updatedMatrix;
            });
          },
          shouldTranslate: true, // Allow translation (panning)
          shouldScale: true, // Allow scaling (pinch-to-zoom)
          shouldRotate: true, // Allow rotation (twist)
          child: Builder(
            builder: (context) {
              return Transform(
                transform: matrix, // Apply the updated matrix here
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                  child: Center(child: Text("Transform Me!")),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
