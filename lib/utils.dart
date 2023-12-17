import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  try {
    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      print('Image selection canceled');
      return null;
    }
  } catch (e) {
    print('Error picking image: $e');
    return null;
  }
}
