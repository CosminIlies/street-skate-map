import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CameraService {
  static Future<File?> pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      print("is null");
      return null;
    }
    print(image.path);
    return File(image.path);
  }

  static Future<File?> pickImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      print("is null");
      return null;
    }

    print(image.path);
    return File(image.path);
  }
}
