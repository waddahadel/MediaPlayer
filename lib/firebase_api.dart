import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';


class FirebasseApi{
  static UploadTask? uploadFile(String destination, File file){
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch(e){
      return null;
    }
  }
}



class FirebasseApi2{
  static UploadTask? uploadFile(String pic_destination, File pic_file){
    try {
      final ref = FirebaseStorage.instance.ref(pic_destination);
      return ref.putFile(pic_file);
    } on FirebaseException catch(e){
      return null;
    }
  }
}