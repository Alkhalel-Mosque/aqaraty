import 'dart:io';

import 'package:aqaraty/components/back_ground_effict.dart';
import 'package:aqaraty/components/image_pick.dart';
import 'package:aqaraty/components/my_snackbar.dart';

import 'package:aqaraty/pages/add_page.dart';
import 'package:aqaraty/provider/image.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:aqaraty/router/router.dart';
import 'package:aqaraty/utils/toast.dart';
import 'package:aqaraty/widgets/info_page_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iconsax/iconsax.dart';
import 'package:aqaraty/components/my_map.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:intl/intl.dart';

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
    final coreProvRead = ref.watch(coreProvider);

    // ✅ الحصول على العقار المحدث من CoreProvider بدلاً من widget.realEstate
    final realEstate = coreProvRead.realEstates.firstWhere(
      (e) => e.id == widget.realEstate.id,
      orElse: () => widget.realEstate, // fallback إلى البيانات الأصلية
    );

    final imagesState = ref.watch(imagesProvider(realEstate.id.toString()));

    final serverImages =
        imagesState.initialUrls.where((url) => url.startsWith("http")).toList();

// الصور الجديدة (ملفات)
    final localFiles = imagesState.compressedFiles;

// الصور المخزنة أوفلاين (file://) لازم تعتبر كملفات محلية
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
                try {
                  final isconected = await ref
                      .read(imagesProvider(realEstate.id.toString()).notifier)
                      .checkConnectivity();
                  if (isconected) {
                    await context.myPush(AddPage(
                      realEstate: realEstate,
                    ));
                    await ref.read(coreProvider).featchData();

                    ref
                        .read(imagesProvider(realEstate.id.toString()).notifier)
                        .refreshFromCore();
                  } else {
                    MySnackBar.showMySnackBar('لا يوجد اتصال بالانترنت',
                        contentType: ContentType.warning);
                  }
                } catch (e) {
                  CustomToast.showToast('لا يوجد اتصال بالانترنت $e');
                }
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
                          realEstateId: realEstate.id.toString(),
                          isEdit: false,
                          onFilePicked: (List<File> files) {},
                        ),
                      ],
                      context),
                gridSection(
                    "المعلومات الأساسية",
                    [
                      infoBox(
                        realEstate,
                        Iconsax.user,
                        "منشئ الطلب",
                        coreProvRead.user?.username ?? "-",
                        false,
                      ),
                      infoBox(realEstate, Iconsax.verify, "الإكساء",
                          realEstate.condition?.arName ?? "-", false),
                      infoBox(realEstate, Iconsax.add_square, "نوع الإضافة",
                          realEstate.type?.arNameTitle ?? "-", false),
                      infoBox(realEstate, Iconsax.buildings, "نوع العقار",
                          realEstate.propertyType?.arName ?? "-", false),
                    ],
                    context),
                const SizedBox(height: 12),
                cardSection(
                    "الموقع",
                    [
                      infoBox(realEstate, Iconsax.location, "الموقع",
                          realEstate.locationArea ?? "-", false),
                      if (realEstate.coords != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 200,
                            child: MyMap(
                              isEdite: false,
                              coords: realEstate.coords,
                              onSave: (_) {},
                            ),
                          ),
                        ),
                      if ((realEstate.locationMark ?? "").isNotEmpty)
                        infoBox(realEstate, Iconsax.flag, "علامة",
                            realEstate.locationMark ?? "-", false),
                    ],
                    context),
                const SizedBox(height: 12),
                gridSection(
                    "تفاصيل العقار",
                    [
                      infoBox(
                          realEstate,
                          Iconsax.money,
                          "السعر المتوقع",
                          "${NumberFormat.decimalPattern().format(realEstate.price ?? 0)} ${realEstate.currency?.symbol ?? ''}",
                          false),
                      infoBox(realEstate, Iconsax.maximize_4, "المساحة",
                          "${realEstate.area ?? '-'}", false),
                      infoBox(realEstate, Iconsax.setting4, "الطابق",
                          ordinalsAr(realEstate.floor) ?? "-", false),
                      infoBox(realEstate, Iconsax.house_2, "عدد الغرف",
                          "${realEstate.rooms}", true),
                      infoBox(realEstate, Iconsax.designtools, " الفرش",
                          "${realEstate.furnishing?.arName}", false),
                      infoBox(realEstate, Iconsax.ram, " الملكية",
                          "${realEstate.ownershipType?.arName}", false),
                    ],
                    context),
                cardSection(
                    'تفاصيل الزبون ',
                    [
                      infoBox(realEstate, Iconsax.profile_2user, 'اسم الزبون',
                          "${realEstate.customerName}", false),
                      infoBoxWithActions(context, Iconsax.call, 'رقم الزبون',
                          realEstate.customerPhone.toString()),
                    ],
                    context),
                if ((realEstate.officeName ?? "").isNotEmpty ||
                    (realEstate.officePhone ?? "").isNotEmpty)
                  cardSection(
                      'تفاصيل المكتب ',
                      [
                        infoBox(realEstate, Iconsax.profile_2user, 'اسم المكتب',
                            "${realEstate.officeName}", false),
                        infoBoxWithActions(context, Iconsax.call, 'رقم المكتب',
                            realEstate.officePhone.toString()),
                      ],
                      context),
                if ((realEstate.additionalInformation ?? "").isNotEmpty)
                  cardSection(
                      'ملاحظة',
                      [
                        infoBox(realEstate, Iconsax.note, 'معلومات اضافية ',
                            "${realEstate.additionalInformation}", false)
                      ],
                      context),
                if (realEstate.iswithSalon == false ||
                    realEstate.iswithSofa == false ||
                    realEstate.iswithRoof == false ||
                    (realEstate.direction ?? []).isNotEmpty ||
                    (realEstate.features ?? []).isNotEmpty)
                  cardSection(
                      "المميزات الإضافية",
                      [
                        if ((realEstate.direction ?? []).isNotEmpty) ...[
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
                            children: realEstate.direction!
                                .map((d) => Chip(
                                      side: BorderSide(
                                          width: 0.7, color: theme.focusColor),
                                      surfaceTintColor: theme.cardColor,
                                      color: WidgetStateProperty.all(
                                          theme.cardColor),
                                      label: Text(d.arName),
                                      backgroundColor: theme.cardColor,
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if ((realEstate.features ?? []).isNotEmpty) ...[
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
                            children: realEstate.features!
                                .map((f) => Chip(
                                      side: BorderSide(
                                          width: 0.7, color: theme.focusColor),
                                      surfaceTintColor: theme.cardColor,
                                      color: WidgetStateProperty.all(
                                          theme.cardColor),
                                      label: Text(f.arName),
                                      shadowColor: theme.cardColor,
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
