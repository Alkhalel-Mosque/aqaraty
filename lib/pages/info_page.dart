import 'dart:io';

import 'package:aqaraty/components/back_ground_effict.dart';
import 'package:aqaraty/components/image_pick.dart';

import 'package:aqaraty/pages/add_page.dart';
import 'package:aqaraty/provider/image.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:aqaraty/router/router.dart';
import 'package:aqaraty/widgets/info_page_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:iconsax/iconsax.dart';
import 'package:aqaraty/components/my_map.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends ConsumerStatefulWidget {
  final RealEstate realEstate;
  const InfoPage({super.key, required this.realEstate});

  @override
  ConsumerState<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends ConsumerState<InfoPage> {
  void initState() {
    super.initState();

    final realEstate = widget.realEstate;

    final initialImages =
        (realEstate.localGalleryImagePaths?.isNotEmpty ?? false)
            ? realEstate.localGalleryImagePaths!
            : (realEstate.galleryImageIds ?? []);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(imagesProvider(realEstate.id.toString()).notifier)
          .setInitialUrls(initialImages, override: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coreProvRead = ref.read(coreProvider);
    final imagesState =
        ref.watch(imagesProvider(widget.realEstate.id.toString()));

    final serverImages =
        imagesState.initialUrls.where((url) => url.startsWith("http")).toList();

    final localFiles = imagesState.compressedFiles;

    final offlineImages = imagesState.initialUrls
        .where((url) => url.startsWith("file://"))
        .map((path) => File(path.replaceFirst("file://", "")))
        .toList();

    final displayItems = [
      ...serverImages,
      ...localFiles,
      ...offlineImages
          .where((file) => !localFiles.any((local) => local.path == file.path)),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: theme.canvasColor,
        ),
        actionsIconTheme: IconThemeData(
          color: theme.canvasColor,
        ),
        title: Text(
          "عرض عقار",
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.outline,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: IconButton(
              icon: const Icon(Iconsax.edit),
              onPressed: () async {
                await context.myPush(AddPage(
                  realEstate: widget.realEstate,
                ));
                // ✅ تحديث حالة الصور بعد العودة من التعديل
                ref.invalidate(imagesProvider(widget.realEstate.id.toString()));
                // ✅ إعادة تحميل البيانات من CoreProvider
                ref.read(coreProvider).featchData();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          background(context),
          circl1(context),
          circl2(context),
          SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                if ((displayItems).isNotEmpty)
                  cardSection(
                      "معرض الصور",
                      [
                        EnhancedImageCompressor(
                          isShow: true,
                          realEstateId: widget.realEstate.id.toString(),
                          isEdit: false,
                          onFilePicked: (List<File> files) {},
                        ),
                      ],
                      context),
                gridSection(
                    "المعلومات الأساسية",
                    [
                      infoBox(
                        widget.realEstate,
                        Iconsax.user,
                        "منشئ الطلب",
                        coreProvRead.user?.username ?? "-",
                        false,
                      ),
                      infoBox(widget.realEstate, Iconsax.verify, "الإكساء",
                          widget.realEstate.condition?.arName ?? "-", false),
                      infoBox(
                          widget.realEstate,
                          Iconsax.add_square,
                          "نوع الإضافة",
                          widget.realEstate.type?.arNameTitle ?? "-",
                          false),
                      infoBox(
                          widget.realEstate,
                          Iconsax.buildings,
                          "نوع العقار",
                          widget.realEstate.propertyType?.arName ?? "-",
                          false),
                    ],
                    context),
                const SizedBox(height: 12),
                cardSection(
                    "الموقع",
                    [
                      infoBox(widget.realEstate, Iconsax.location, "الموقع",
                          widget.realEstate.locationArea ?? "-", false),
                      if (widget.realEstate.coords != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 200,
                            child: MyMap(
                              isEdite: false,
                              coords: widget.realEstate.coords,
                              onSave: (_) {},
                            ),
                          ),
                        ),
                      if ((widget.realEstate.locationMark ?? "").isNotEmpty)
                        infoBox(widget.realEstate, Iconsax.flag, "علامة",
                            widget.realEstate.locationMark ?? "-", false),
                    ],
                    context),
                const SizedBox(height: 12),
                gridSection(
                    "تفاصيل العقار",
                    [
                      infoBox(
                          widget.realEstate,
                          Iconsax.money,
                          "السعر المتوقع",
                          "${widget.realEstate.price} ${widget.realEstate.currency?.symbol}",
                          false),
                      infoBox(widget.realEstate, Iconsax.maximize_4, "المساحة",
                          "${widget.realEstate.area ?? '-'}", false),
                      infoBox(widget.realEstate, Iconsax.setting4, "الطابق",
                          ordinalsAr(widget.realEstate.floor) ?? "-", false),
                      infoBox(widget.realEstate, Iconsax.house_2, "عدد الغرف",
                          "${widget.realEstate.rooms}", true),
                      infoBox(widget.realEstate, Iconsax.designtools, " الفرش",
                          "${widget.realEstate.furnishing?.arName}", false),
                      infoBox(widget.realEstate, Iconsax.ram, " الملكية",
                          "${widget.realEstate.ownershipType?.arName}", false),
                    ],
                    context),
                cardSection(
                    'تفاصيل الزبون ',
                    [
                      infoBox(
                          widget.realEstate,
                          Iconsax.profile_2user,
                          'اسم الزبون',
                          "${widget.realEstate.customerName}",
                          false),
                      infoBoxWithActions(context, Iconsax.call, 'رقم الزبون',
                          widget.realEstate.customerPhone.toString()),
                    ],
                    context),
                if ((widget.realEstate.officeName ?? "").isNotEmpty ||
                    (widget.realEstate.officePhone ?? "").isNotEmpty)
                  cardSection(
                      'تفاصيل المكتب ',
                      [
                        infoBox(
                            widget.realEstate,
                            Iconsax.profile_2user,
                            'اسم المكتب',
                            "${widget.realEstate.officeName}",
                            false),
                        infoBoxWithActions(context, Iconsax.call, 'رقم المكتب',
                            widget.realEstate.officePhone.toString()),
                      ],
                      context),
                if ((widget.realEstate.additionalInformation ?? "").isNotEmpty)
                  cardSection(
                      'ملاحظة',
                      [
                        infoBox(
                            widget.realEstate,
                            Iconsax.note,
                            'معلومات اضافية ',
                            "${widget.realEstate.additionalInformation}",
                            false)
                      ],
                      context),
                if (widget.realEstate.iswithSalon == false ||
                    widget.realEstate.iswithSofa == false ||
                    widget.realEstate.iswithRoof == false ||
                    (widget.realEstate.direction ?? []).isNotEmpty ||
                    (widget.realEstate.features ?? []).isNotEmpty)
                  cardSection(
                      "المميزات الإضافية",
                      [
                        if ((widget.realEstate.direction ?? []).isNotEmpty) ...[
                          Text(
                            "الاتجاهات:",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 16,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: widget.realEstate.direction!
                                .map((d) => Chip(
                                      label: Text(d.arName),
                                      backgroundColor: theme.cardColor,
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if ((widget.realEstate.features ?? []).isNotEmpty) ...[
                          Text(
                            "الميزات:",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 16,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: widget.realEstate.features!
                                .map((f) => Chip(
                                      label: Text(f.arName),
                                      backgroundColor: theme.cardColor,
                                    ))
                                .toList(),
                          ),
                        ],
                        const Divider(
                          thickness: 0,
                        )
                      ],
                      context),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? ordinalsAr(int? floor) {
    if (floor == null) return null;
    switch (floor) {
      case 0:
        return "أرضي";
      case 1:
        return "الأول";
      case 2:
        return "الثاني";
      case 3:
        return "الثالث";
      default:
        return "$floor";
    }
  }
}
