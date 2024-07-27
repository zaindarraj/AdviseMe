import 'package:image_picker/image_picker.dart';

class ImageModel {
  static Future<String?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image is XFile) {
      return image.path;
    } else {
      return null;
    }
  }

}
