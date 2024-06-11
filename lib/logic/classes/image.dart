import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';

class ImageModel {
  static Future<String?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image is XFile) {
      return image.path;
    } else {
      return null;
    }
  }

}
