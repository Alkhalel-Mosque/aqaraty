import 'package:aqaraty/image/domain/repositories/image_repository.dart';

class UploadImage {
  final ImageRepository repository;

  UploadImage(this.repository);

  Future<String?> call(String imagePath) {
    return repository.uploadImage(imagePath);
  }
}
