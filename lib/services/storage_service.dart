import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<String> uploadImage(String uid, File _image) async {
    // Upload image to Firebase Storage
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');

    UploadTask uploadTask = storageReference.putFile(_image);

    await uploadTask.whenComplete(() => null);

    // Retrieve download URL
    String downloadUrl = await storageReference.getDownloadURL();

    return downloadUrl;
  }
}
