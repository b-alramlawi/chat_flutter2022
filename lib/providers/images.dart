import 'package:flutter/cupertino.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImagesProvider extends ChangeNotifier {
  List<Asset> _images = [];

  List<Asset> get images => _images;

  set setImages(List<Asset> value) {
    _images = value;
    notifyListeners();
  }
}
