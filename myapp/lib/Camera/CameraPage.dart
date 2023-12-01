import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Home/VideoPreview.dart';

class Camera_Page extends StatefulWidget {
  Camera_Page({super.key});

  @override
  State<Camera_Page> createState() => _Camera_PageState();
}

class _Camera_PageState extends State<Camera_Page> {
  bool isloading = true;
  bool isRecording = false;
  late CameraController cameraController;

  @override
  void initState() {
    super.initState();
    initcamera();
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Stack(
        children: [
          CameraPreview(cameraController),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: recording,
                  child: Icon(isRecording == true ? Icons.stop : Icons.circle),
                ),
                Text(
                  isRecording ? "Stop Recording" : "Start Recording",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0, // Adjust the font size as needed
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }
  }

  initcamera() async {
    final cameras = await availableCameras();
    final back = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    cameraController = CameraController(back, ResolutionPreset.max);
    await cameraController.initialize();
    setState(() {
      isloading = false;
    });
  }

  recording() async {
    if (isRecording) {
      final XFile file = await cameraController.stopVideoRecording();
      setState(() {
        isRecording = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPreview(filepath: file.path),
        ),
      );
    } else {
      await cameraController.prepareForVideoRecording();
      await cameraController.startVideoRecording();
      setState(() {
        isRecording = true;
      });
    }
  }
}
