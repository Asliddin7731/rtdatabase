
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StoreService {
  static final storage = FirebaseStorage.instance.ref();

  Future<String?> uploadImage(File image, String uid) async {
    try {
      final String imgName = '${uid}_${DateTime.now()}';
      final ref = storage.child('studentsAttendanceImages').child(imgName);
      final UploadTask uploadTask = ref.putFile(image, SettableMetadata(
        contentType: 'image/png',
      ));
      final snapshot = await uploadTask.whenComplete(() => {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      return urlDownload;
    } on Exception catch (e) {
      print('Upload Image Error!');
    }
    return null;
  }
}