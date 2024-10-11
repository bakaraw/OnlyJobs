import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FileService {
  Uint8List? fileBuffer;
  String? fileName;

  Future<Uint8List?> selectFile() async {
    if (kIsWeb) {
      // Web: Use FilePicker to get the file as Uint8List
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        fileBuffer = result.files.first.bytes; // Store file in Uint8List
        fileName = result.files.first.name;
        print("Selected file: $fileName");
        return fileBuffer;
      }
    } else {
      // Mobile: Use FilePicker to get the file path and read it as bytes
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        File file = File(result.files.single.path!);
        fileName = result.files.single.name;
        fileBuffer = await file.readAsBytes(); // Store file in Uint8List
        return fileBuffer;
      }
    }

    if (fileBuffer == null) {
      print("No file selected.");
      return null;
    } else {
      return fileBuffer;
    }
  }

  Future<String?> uploadFileToFirebase(String uid) async {
    if (fileBuffer != null) {
      try {
        // create a unique file name
        String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
        String extension = fileName!.split('.').last;

        final storageRef =
            FirebaseStorage.instance.ref().child('$uid/$uniqueName.$extension');
        await storageRef.putData(fileBuffer!);

        String downloadURL = await storageRef.getDownloadURL();
        print("File uploaded successfully!");
        return downloadURL;
      } catch (e) {
        print("Failed to upload file: $e");
      }
    } else {
      print("No file selected to upload.");
    }
    return null;
  }

  // fetch file form fireebase storage
  Future<Uint8List?> fetchFileFromFirebase(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      fileBuffer = await ref.getData();
      return fileBuffer;
    } catch (e) {
      print("Failed to fetch file: $e");
      return null;
    }
  }

  // delete file from firebase storage
  Future<void> deleteFileFromFirebase(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
      print("File deleted successfully!");
    } catch (e) {
      print("Failed to delete file: $e");
    }
  }
}
