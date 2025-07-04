import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CustomImageSlider extends StatefulWidget {
  @override
  _CustomImageSliderState createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  List<dynamic> _images = []; // Can be File, String (url), or AssetImage
  int _currentIndex = 0;

  Future<void> _addImage() async {
    final result = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Image"),
        content: Text("Choose image source"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text("Camera"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text("Gallery"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text("Network Image"),
          ),
        ],
      ),
    );

    if (result == null) {
      // Add network image
      final url = await showDialog<String>(
        context: context,
        builder: (context) {
          String url = '';
          return AlertDialog(
            title: Text("Add Network Image"),
            content: TextField(
              onChanged: (value) => url = value,
              decoration: InputDecoration(hintText: "Enter image URL"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, url),
                child: Text("Add"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
            ],
          );
        },
      );
      if (url != null && url.isNotEmpty) {
        setState(() => _images.add(url));
      }
    } else if (result == ImageSource.gallery) {
      // Pick from gallery
      final pickedFile = await ImagePicker().pickImage(source: result);
      if (pickedFile != null) {
        setState(() => _images.add(File(pickedFile.path)));
      }
    } else if (result == ImageSource.camera) {
      // Take photo
      final pickedFile = await ImagePicker().pickImage(source: result);
      if (pickedFile != null) {
        setState(() => _images.add(File(pickedFile.path)));
      }
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
      if (_currentIndex >= _images.length) {
        _currentIndex = _images.length - 1;
      }
    });
  }

  Widget _imageWidget(dynamic image) {
    if (image is File) {
      return Image.file(image, fit: BoxFit.cover);
    } else if (image is String) {
      return CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else {
      return Container(); // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: 300,
                viewportFraction: 0.8,
                autoPlay: false,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() => _currentIndex = index);
                },
              ),
              items: _images.asMap().entries.map((entry) {
                final index = entry.key;
                final image = entry.value;
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: _imageWidget(image),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteImage(index),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
            if (_images.isEmpty)
              Text(
                "No images added",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _images.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Colors.blue
                    : Colors.grey.withOpacity(0.4),
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => _carouselController.previousPage(),
            ),
            FloatingActionButton(
              onPressed: _addImage,
              child: Icon(Icons.add),
              mini: true,
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () => _carouselController.nextPage(),
            ),
          ],
        ),
      ],
    );
  }
}