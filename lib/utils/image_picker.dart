import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:developer';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:image_picker/image_picker.dart' as img_p;
import 'dart:typed_data';

class ImagePicker {
  Future<File?> getImageFromGallery(BuildContext context) async {
    try {
      List<MediaFile>? singleMediaFile =
          await GalleryPicker.pickMedia(context: context, singleMedia: true);
      if (singleMediaFile != null && singleMediaFile.isNotEmpty) {
        return singleMediaFile.first.getFile();
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<Uint8List?> getImageFromFiles() async {
    final img_p.ImagePicker _picker = img_p.ImagePicker();
    img_p.XFile? image = await _picker.pickImage(source: img_p.ImageSource.gallery);
    if (image != null) {
      var f = await image.readAsBytes();
      return f;
    }
    return null;
  }
}
