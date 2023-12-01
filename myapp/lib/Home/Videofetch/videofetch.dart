import 'package:flutter/material.dart';
import 'package:myapp/Camera/CameraPage.dart';
import 'package:myapp/Home/videoplayer/videoplayer.dart';
import 'package:myapp/Model/VideoMeta.dart';
import 'package:myapp/firebase/getfile.dart';

class VideoListPage extends StatefulWidget {
  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  final test = Firebase_getfile();
  late Future<List<VideoMetaData>> videoMetadataFuture;

  @override
  void initState() {
    super.initState();
    videoMetadataFuture = test.printAllDownloadLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
      ),
      body: FutureBuilder(
        future: videoMetadataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<VideoMetaData> videoMetadataList =
                snapshot.data as List<VideoMetaData>;

            return ListView.builder(
              itemCount: videoMetadataList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.play_arrow),
                      Text("${videoMetadataList[index].videodescription}.mp4"),
                    ],
                  ),
                  subtitle: Text("Tap to Play"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerPage(
                          videoUrl: videoMetadataList[index].downloadurl,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Camera_Page()));
            },
            child: Icon(Icons.camera),
          ),
          Text(
            "Record",
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
