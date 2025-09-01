import 'package:aqaraty/image/domain/repositories/image_repository.dart';

class UploadMultipleImages {
  final ImageRepository repository;

  UploadMultipleImages(this.repository);

  Future<List<String>> call(List<String> imagePaths) {
    return repository.uploadMultipleImages(imagePaths);
  }
}
