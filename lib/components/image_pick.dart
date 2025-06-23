import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
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
    widget.onFilePicked([...initFiles, ..._compressedImages]);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openImage(dynamic image) async {
    try {
      if (image is String) {
        final file = await _cacheManager.getSingleFile(image);
        await OpenFile.open(file.path);
      } else if (image is File) {
        await OpenFile.open(image.path);
      }
    } catch (e) {
      _showError('Could not open image: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    final displayItems = [..._initialImageUrls, ..._compressedImages];

    return SizedBox(
      height: 320,
      child: Column(
        children: [

          // Header with total info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${displayItems.length} image(s)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                FutureBuilder<int>(
                  future: Future.wait(displayItems.map(_getFileSize))
                      .then((sizes) => sizes.fold(0, (a, b) => a)),
                  builder: (context, snapshot) {
                    return Text(
                      'Size: ${snapshot.hasData ? _formatFileSize(snapshot.data!) : 'calculating...'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
          ),

          // Image display row
          Expanded(
            child: displayItems.isEmpty
                ? const Center(child: Text('No images selected'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: displayItems.length,
                    itemBuilder: (context, index) {
                      final item = displayItems[index];
                      final isUrl = item is String;

                      return FutureBuilder<int>(
                        future: _getFileSize(item),
                        builder: (context, sizeSnapshot) {
                          return GestureDetector(
                            onTap: () => _openImage(item),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 180,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: isUrl
                                            ? CachedNetworkImage(
                                                imageUrl: item,
                                                fit: BoxFit.cover,
                                                cacheManager: _cacheManager,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )
                                            : Image.file(
                                                item as File,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      if (widget.isEdit)
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                Colors.red.withOpacity(0.8),
                                            child: IconButton(
                                              icon: const Icon(Icons.close,
                                                  size: 15,
                                                  color: Colors.white),
                                              onPressed: () =>
                                                  _deleteImage(index),
                                            ),
                                          ),
                                        ),
                                      if (isUrl)
                                        Positioned(
                                          bottom: 5,
                                          left: 5,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'Server',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    sizeSnapshot.hasData
                                        ? _formatFileSize(sizeSnapshot.data!)
                                        : '...',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        
          if (widget.isEdit)
          // Controls
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Add Images'),
                    onPressed: _isCompressing ? null : _pickImages,
                  ),
                  if (_pickedImages.isNotEmpty && !_isCompressing)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.compress),
                      label: const Text('Compress New'),
                      onPressed: _compressNewImages,
                    ),
                ],
              ),
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
