abstract class ImageRepository {
  Future<String?> uploadImage(String imagePath);
  Future<List<String>> uploadMultipleImages(List<String> imagePaths);
}
