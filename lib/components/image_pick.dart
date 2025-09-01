import 'dart:io';

import 'package:aqaraty/widgets/gallery_view.dart';
import 'package:aqaraty/provider/image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class EnhancedImageCompressor extends ConsumerStatefulWidget {
  final String realEstateId;
  final void Function(List<File> files) onFilePicked;
  final bool isEdit;
  final bool isShow;

  const EnhancedImageCompressor({
    super.key,
    required this.realEstateId,
    required this.onFilePicked,
    required this.isEdit,
    required this.isShow,
  });

  @override
  ConsumerState<EnhancedImageCompressor> createState() =>
      _EnhancedImageCompressorState();
}

class _EnhancedImageCompressorState
    extends ConsumerState<EnhancedImageCompressor> {
  final ImagePicker _picker = ImagePicker();
  bool _isCompressing = false;
  int _currentIndex = 0;

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final selected = pickedFiles.map((f) => File(f.path)).toList();
        await _compressNewImages(selected);
      }
    } catch (e) {
      _showError('خطأ أثناء اختيار الصور: $e');
    }
  }

  Future<void> _compressNewImages(List<File> newImages) async {
    setState(() => _isCompressing = true);

    try {
      final tempDir = await getTemporaryDirectory();
      final List<File> newlyCompressed = [];

      for (var image in newImages) {
        final compressedPath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        final result = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path,
          compressedPath,
          quality: 70,
          minWidth: 1024,
          minHeight: 1024,
        );

        if (result != null) newlyCompressed.add(File(result.path));
      }

      ref
          .read(imagesProvider(widget.realEstateId).notifier)
          .addCompressedFiles(newlyCompressed);

      _updateParentWithCurrentFiles();
    } catch (e) {
      _showError('فشل الضغط: $e');
    } finally {
      setState(() => _isCompressing = false);
    }
  }

  void _updateParentWithCurrentFiles() {
    final imagesState = ref.read(imagesProvider(widget.realEstateId));
    final List<File> allFiles = [
      ...imagesState.compressedFiles,
      ...imagesState.initialUrls
          .where((url) => url.startsWith("file://"))
          .map((p) => File(p.replaceFirst("file://", ""))),
    ];
    widget.onFilePicked(allFiles);
  }

  Future<void> _openImage(int index) async {
    final imagesState = ref.read(imagesProvider(widget.realEstateId));
    final displayItems = [
      ...imagesState.initialUrls,
      ...imagesState.compressedFiles
    ];

    if (index >= 0 && index < displayItems.length) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GalleryView(
            pageController: PageController(initialPage: index),
            galleryItems: displayItems
                .map((e) => GalleryItem(
                      id: "id",
                      imageUrl: (e is File) ? e.path : e as String,
                    ))
                .toList(),
            onPageChanged: (index) {},
          ),
        ),
      );
    }
  }

  Widget _imageWidget(dynamic image) {
    if (image is File) {
      return Image.file(image, fit: BoxFit.cover);
    } else if (image is String) {
      if (image.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      } else {
        return Image.file(File(image), fit: BoxFit.cover);
      }
    }
    return const SizedBox();
  }

  Future<void> _confirmDelete(int index) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text(
              'هل تريد وضع علامة على هذه الصورة للحذف؟ سيتم الحذف النهائي عند الضغط على حفظ.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      ref
          .read(imagesProvider(widget.realEstateId).notifier)
          .markForDeletion(index);
    }
  }

  void _undoDelete(int index) {
    ref
        .read(imagesProvider(widget.realEstateId).notifier)
        .unmarkForDeletion(index);
  }

  Widget _addWidget() {
    return InkWell(
      onTap: _pickImages,
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).canvasColor),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Icon(
          Icons.add_a_photo_outlined,
          size: 60,
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagesState = ref.watch(imagesProvider(widget.realEstateId));

    final serverImages =
        imagesState.initialUrls.where((url) => url.startsWith("http")).toList();

    final localFiles = imagesState.compressedFiles;

    final offlineImages = imagesState.initialUrls
        .where((url) => url.startsWith("file://"))
        .map((path) => File(path.replaceFirst("file://", "")))
        .toList();

    final displayItems = widget.isShow
        ? [...serverImages, ...offlineImages, ...localFiles]
        : [...serverImages, ...localFiles];

    return SizedBox(
      height: displayItems.isEmpty ? 150 : 320,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('عدد الصور: (${displayItems.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if (widget.isEdit && displayItems.isNotEmpty)
                  IconButton(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.add_a_photo_outlined),
                  ),
              ],
            ),
          ),
          Expanded(
            child: displayItems.isEmpty
                ? _addWidget()
                : CarouselSlider.builder(
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      viewportFraction: 0.8,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      onPageChanged: (index, _) =>
                          setState(() => _currentIndex = index),
                    ),
                    itemCount: displayItems.length,
                    itemBuilder: (context, index, _) {
                      final item = displayItems[index];
                      final isPendingDeletion =
                          imagesState.pendingDeletion.contains(index);

                      return GestureDetector(
                        key: ValueKey(item.hashCode),
                        onTap: () => _openImage(index),
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Opacity(
                                opacity: isPendingDeletion ? 0.5 : 1.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: _imageWidget(item),
                                ),
                              ),
                            ),
                            if (widget.isEdit)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: isPendingDeletion
                                    ? IconButton(
                                        icon: const Icon(Icons.undo,
                                            color: Colors.blue),
                                        onPressed: () => _undoDelete(index),
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _confirmDelete(index),
                                      ),
                              ),
                            if (isPendingDeletion)
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'محذوف',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (displayItems.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: displayItems.asMap().entries.map((entry) {
                final isPendingDeletion =
                    imagesState.pendingDeletion.contains(entry.key);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPendingDeletion
                        ? Colors.red
                        : _currentIndex == entry.key
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

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
