import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
class Firebase_Storage {
  Reference storageRef = FirebaseStorage.instance.ref();

  Future<void> uploadFile(File file,String Videodescription) async {
    try {
      String fileName = DateTime.now()
          .millisecondsSinceEpoch
          .toString(); 
         SettableMetadata metadata= SettableMetadata(
          customMetadata:{
            'description' : Videodescription,
            }
          );
      Reference fileRef =
          storageRef.child('Video/$fileName'); 
      await fileRef.putFile(file,metadata);
      print('Upload success');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

   Future<void> printAllDownloadLinks() async {
    try {
      ListResult result = await storageRef.child('Video').listAll();

      for (Reference ref in result.items) {
        String downloadURL = await ref.getDownloadURL();
        print('Download URL: $downloadURL');
      }
    } catch (e) {
      print('Error fetching download links: $e');
    }
  }
}
