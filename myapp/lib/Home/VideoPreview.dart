import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/Camera/CameraPage.dart';
import 'package:myapp/Home/Videofetch/videofetch.dart';
import 'package:myapp/firebase/upload.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  VideoPreview({super.key, required this.filepath});
  final String filepath;
  late final File file = File(filepath);

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController videocontroller;
  var fileupload = Firebase_Storage();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initVideoplayer();
  }

  @override
  void dispose() {
    videocontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: FutureBuilder(
                    future: initVideoplayer(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return VideoPlayer(videocontroller);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: controller,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter video title',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      fileupload.uploadFile(widget.file, controller.text);
                    },
                    child: Icon(Icons.upload),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoListPage(),
                          ));
                    },
                    child: Icon(Icons.more),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Camera_Page(),
                          ));
                    },
                    child: Icon(Icons.cancel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initVideoplayer() async {
    print("This is filepath");
    print(widget.filepath);
    videocontroller =
        VideoPlayerController.file(File(widget.filepath.toString()));
    await videocontroller.initialize();
    await videocontroller.setLooping(true);
    await videocontroller.play();
  }
}
