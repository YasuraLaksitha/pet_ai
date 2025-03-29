import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';


class ScannerService {
  Future<void> initialize() async {
    try {
      await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
    } catch (e) {
      throw Exception("Model loading failed: $e");
    }
  }

  Future<Map<String, dynamic>?> scanPet({bool useCamera = false}) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: useCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile == null) return null;

    File imageFile = File(pickedFile.path);

    var recognitions = await Tflite.runModelOnImage(
      path: imageFile.path,
      numResults: 3,
      threshold: 0.4,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      return {
        'image': imageFile,
        'category': recognitions[0]['label'],
        'confidence': recognitions[0]['confidence'] * 100,
        'isPet': true,
      };
    } else {
      return {'image': imageFile, 'category': "Unknown", 'isPet': false};
    }
  }

  void dispose() {
    Tflite.close();
  }
}
