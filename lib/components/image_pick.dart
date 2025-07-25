import 'package:aqaraty/pages/gallery_view.dart';
import 'package:aqaraty/router/router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

class EnhancedImageCompressor extends StatefulWidget {
  final void Function(List<File> files) onFilePicked;
  final List<String> initialImageUrls;
  final bool isEdit;

  const EnhancedImageCompressor({
    super.key,
    required this.onFilePicked,
    this.initialImageUrls = const [],
    required this.isEdit,
  });

  @override
  State<EnhancedImageCompressor> createState() =>
      _EnhancedImageCompressorState();
}

class _EnhancedImageCompressorState extends State<EnhancedImageCompressor> {
  final ImagePicker _picker = ImagePicker();
  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  List<File> _pickedImages = [];

  List<String> _initialImageUrls = [];
  int _currentIndex = 0;
  List<File> _compressedImages = [];

  bool _isCompressing = false;

  @override
  void initState() {
    super.initState();
    _initialImageUrls = List.from(widget.initialImageUrls);
    _precacheInitialImages();
  }

  Future<void> _precacheInitialImages() async {
    for (var url in _initialImageUrls) {
      await _cacheManager.getSingleFile(url);
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _pickedImages
              .addAll(pickedFiles.map((file) => File(file.path)).toList());
        });
        _compressNewImages();
      }
    } catch (e) {
      _showError('Error picking images: $e');
    }
  }

  Future<void> _compressNewImages() async {
    if (_pickedImages.isEmpty) return;

    setState(() {
      _isCompressing = true;
    });

    try {
      final tempDir = await getTemporaryDirectory();

      for (var image in _pickedImages) {
        final compressedPath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final result = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path,
          compressedPath,
          quality: 70,
          minWidth: 1024,
          minHeight: 1024,
        );

        if (result != null) {
          setState(() {
            _compressedImages.add(File(result.path));
          });
        }
      }
      _pickedImages.clear();
    } catch (e) {
      _showError('Error compressing images: $e');
    } finally {
      _updateParentWithCurrentFiles();
      setState(() {
        _isCompressing = false;
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      if (index < _initialImageUrls.length) {
        _initialImageUrls.removeAt(index);
      } else {
        _compressedImages.removeAt(index - _initialImageUrls.length);
      }
      _updateParentWithCurrentFiles();
    });
  }

  void _updateParentWithCurrentFiles() async {
    final List<File> initFiles = [];
    for (var e in _initialImageUrls) {
      initFiles.add(await _cacheManager.getSingleFile(e));
    }
    //////////////////////////////////////////////////////
    final allFiles = [...initFiles, ..._compressedImages];
    print("📦 الصور المرسلة إلى parent: ${allFiles.length}");
    for (var file in allFiles) {
      print("📸 ${file.path} | ${file.lengthSync()} bytes");
    }
    widget.onFilePicked([...initFiles, ..._compressedImages]);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openImage(int index) async {
    final displayItems = [..._initialImageUrls, ..._compressedImages];
    context.myPush(GalleryView(
      pageController: PageController(initialPage: index),
      galleryItems: displayItems
          .map(
            (e) => GalleryItem(
                id: "id", imageUrl: (e is File) ? e.path : e as String),
          )
          .toList(),
      onPageChanged: (index) {
        print('Page changed to $index');
      },
    ));
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<int> _getFileSize(dynamic image) async {
    if (image is String) {
      final file = await _cacheManager.getSingleFile(image);
      return file.lengthSync();
    } else if (image is File) {
      return image.lengthSync();
    }
    return 0;
  }

  Widget _imageWidget(dynamic image) {
    if (image is File) {
      return Image.file(image, fit: BoxFit.cover);
    } else if (image is String) {
      return CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else {
      return Container(); // Fallback
    }
  }

  Widget _addWidget() {
    return InkWell(
      onTap: _pickImages,
      child: Container(
        width: MediaQuery.sizeOf(context).width - 50,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Icon(
          Icons.add_a_photo_outlined,
          size: 60,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = [..._initialImageUrls, ..._compressedImages];

    return SizedBox(
      height: displayItems.isEmpty ? 150 : 320,
      child: Column(
        children: [
          // Header with total info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عدد الصور: (${displayItems.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (widget.isEdit && displayItems.isNotEmpty)
                  IconButton(
                    onPressed: _pickImages,
                    icon: Icon(Icons.add_a_photo_outlined),
                  )
              ],
            ),
          ),

          // Image display row
          Expanded(
              child: displayItems.isEmpty
                  ? _addWidget()
                  : CarouselSlider.builder(
                      options: CarouselOptions(
                        // height: 220,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.8,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() => _currentIndex = index);
                        },
                      ),
                      itemCount: displayItems.length,
                      itemBuilder:
                          (BuildContext context, int index, int pageViewIndex) {
                        final item = displayItems[index];

                        return FutureBuilder<int>(
                          future: _getFileSize(item),
                          builder: (context, sizeSnapshot) {
                            return GestureDetector(
                                onTap: () => _openImage(index),
                                child: Builder(
                                  builder: (BuildContext context) {
                                    return Stack(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: _imageWidget(item),
                                        ),
                                        if (widget.isEdit)
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () =>
                                                  _deleteImage(index),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ));
                          },
                        );
                      },
                    )),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: displayItems.asMap().entries.map((entry) {
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
          if (_isCompressing)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
