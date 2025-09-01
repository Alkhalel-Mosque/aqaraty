import 'package:aqaraty/image/data/repositories/service.dart';
import 'package:aqaraty/image/domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageService imageService;

  ImageRepositoryImpl({required this.imageService});

  @override
  Future<String?> uploadImage(String imagePath) {
    return imageService.uploadImage(imagePath);
  }

  @override
  Future<List<String>> uploadMultipleImages(List<String> imagePaths) {
    return imageService.uploadMultipleImages(imagePaths);
  }
}
