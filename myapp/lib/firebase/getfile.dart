import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/Model/VideoMeta.dart';

class Firebase_getfile {
  final Storageref = FirebaseStorage.instance.ref();

  Future<List<VideoMetaData>> printAllDownloadLinks() async {
    List<VideoMetaData> downloadurl = [];
    try {
      ListResult result = await Storageref.child('Video').listAll();

      for (Reference ref in result.items) {
        FullMetadata metadata = await ref.getMetadata();
        String downloadURL = await ref.getDownloadURL();
        String description = metadata.customMetadata?['description']??"";
        downloadurl.add(VideoMetaData(videodescription: description, downloadurl: downloadURL));
        
      }
    } catch (e) {
      print('Error fetching download links: $e');
    }
    return downloadurl;
  }
}
