import 'dart:io';

import 'package:aqaraty/components/back_ground_effict.dart';
import 'package:aqaraty/components/image_pick.dart';

import 'package:aqaraty/components/my_snackbar.dart';

import 'package:aqaraty/api/local_data/types_local.dart';

import 'package:aqaraty/models/user.dart';

import 'package:aqaraty/provider/notifiers.dart';

import 'package:aqaraty/widgets/details_widget.dart';
import 'package:aqaraty/widgets/direction_widget.dart';
import 'package:aqaraty/widgets/features_widget.dart';
import 'package:aqaraty/widgets/map_view.dart';

import 'package:aqaraty/widgets/personal_info.dart';
import 'package:aqaraty/widgets/save_data_helper.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extension.dart';
import '../../models/real_estate.dart';
import '../../utils/toast.dart';

import '../../widgets/my_checkbox.dart';

import '../../widgets/my_text_button.dart';
import '../../widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:aqaraty/provider/image.dart';

class AddPage extends ConsumerStatefulWidget {
  final RealEstate? realEstate;

  const AddPage({
    super.key,
    this.realEstate,
  });

  @override
  ConsumerState<AddPage> createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {
  List<File> _newlyPickedImages = [];
  User? createdByUser;

  bool _isLoading = false;

  RealEstate realEstate = RealEstate(
    direction: [],
    features: [],
  );

  RealEstate draft = RealEstate(
    direction: [],
    features: [],
  );

  @override
  @override
  void initState() {
    super.initState();

    if (widget.realEstate?.createdById != null) {
      fetchUserById(widget.realEstate!.createdById!).then((parseUser) {
        if (mounted && parseUser != null) {
          setState(() {
            createdByUser = User.userFromParseUser(parseUser);
          });
        }
      });
    }

    if (widget.realEstate != null) {
      realEstate = widget.realEstate!.copyWith();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(imagesProvider(realEstate.id.toString()).notifier)
            .setInitialUrls(realEstate.galleryImageIds ?? [], override: true);
      });
    }

    ref
        .read(imagesProvider(realEstate.id.toString()).notifier)
        .setupConnectivityListener();
  }

  void _addRealestate() async {
    if (realEstate.type == null) {
      CustomToast.showToast("اختر نوع الإضافة");
      return;
    }
    if (realEstate.propertyType == null) {
      CustomToast.showToast("اختر نوع العقار");
      return;
    }
    if (realEstate.locationArea?.isEmpty ?? false) {
      CustomToast.showToast("يرجى إضافة الموقع");
      return;
    }
    if (realEstate.locationMark == null) {
      CustomToast.showToast("يرجى إضافة علامة");
      return;
    }
    if (realEstate.price == 0) {
      CustomToast.showToast("يرجى إضافة السعر المتوقع");
      return;
    }
    if (realEstate.floor == null) {
      CustomToast.showToast("اختر الطابق");
      return;
    }
    if (realEstate.type!.isOffer && realEstate.rooms == 0) {
      CustomToast.showToast("يرجى إضافة عدد الغرف");
      return;
    }
    if (realEstate.type!.isBuyOrSell && realEstate.direction!.isEmpty) {
      CustomToast.showToast("اختر الاتجاه");
      return;
    }
    if (realEstate.type == Types.buy && realEstate.ownershipType == null) {
      CustomToast.showToast("اختر نوع الملكية");
      return;
    }
    if (realEstate.furnishing == null) {
      CustomToast.showToast("اختر حالة الفرش");
      return;
    }
    if (realEstate.ownershipType == null) {
      CustomToast.showToast("اختر نوع الملكية");
      return;
    }
    if (realEstate.condition == null) {
      CustomToast.showToast("اختر حالة الإكساء");
      return;
    }
    if (realEstate.customerName == null) {
      CustomToast.showToast("يرجى إضافة اسم الزبون");
      return;
    }
    if (realEstate.customerPhone == null) {
      CustomToast.showToast("يرجى إضافة رقم الزبون");
      return;
    }

    if (realEstate.locationArea == null || realEstate.locationArea!.isEmpty) {
      CustomToast.showToast("أدخل الموقع");
      return;
    }
    if (widget.realEstate != null) {
      ref
          .read(imagesProvider(widget.realEstate!.id.toString()).notifier)
          .confirmDeletion();
    }
    setState(() => _isLoading = true);
    await SaveDataHelper.saveData(
      context,
      ref,
      realEstate,
      _newlyPickedImages,
      mounted,
    );

    ref
        .read(imagesProvider(realEstate.id.toString()).notifier)
        .clearLocalImages();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _deleteRealEstate() async {
    final ensure =
        await MySnackBar.showYesNoDialog(context, "هل أنت متأكد من الحذف؟");
    if (ensure && mounted) {
      final res = await ref.read(coreProvider).deleteRealEstate(realEstate.id!);

      if (res && mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
        onWillPop: () async {
          ref
              .read(imagesProvider(realEstate.id.toString()).notifier)
              .clearLocalImages();

          final res =
              (widget.realEstate != null && widget.realEstate != realEstate) ||
                  (realEstate != draft);

          if (res) {
            return await MySnackBar.showYesNoDialog(context, "هل تود الخروج ؟");
          }

          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: theme.canvasColor, // لون زر الرجوع
            ),
            actionsIconTheme: IconThemeData(
              color: theme.canvasColor, // لون أيقونات actions
            ),
            title: Text(
              "إضافة عقار",
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
              ),
            ),
            actions: [
              if (widget.realEstate != null)
                IconButton(
                  color: theme.canvasColor,
                  onPressed: _deleteRealEstate,
                  icon: const Icon(Icons.delete),
                ),
            ],
          ),
          body: Stack(
            children: [
              background(context),
              circl1(context),
              circl2(context),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(
                  children: [
                    PersonalInfo(
                      realEstate: realEstate,
                      onTypeChanged: (p0) {
                        setState(() {
                          realEstate.type = Types.getFromString(p0!);
                        });
                      },
                    ),
                    15.getHightSizedBox,

                    MapViewSc(realEstate: realEstate),
                    15.getHightSizedBox,

                    DetailsWidget(realEstate: realEstate),

                    DirectionWidget(
                      realEstate: realEstate,
                    ),
                    FeaturesWidget(realEstate: realEstate),

                    5.getHightSizedBox,
                    MyTextFormField(
                      realEstate: realEstate,
                      isrequired: false,
                      labelText: "معلومات إضافية",
                      initVal: realEstate.additionalInformation,
                      textInputType: TextInputType.multiline,
                      onChanged: (p0) {
                        realEstate.additionalInformation = p0;
                      },
                    ),
                    10.getHightSizedBox,
                    MyTextFormField(
                      realEstate: realEstate,
                      initVal: realEstate.customerName,
                      labelText: "اسم الزبون",
                      onChanged: (p0) {
                        realEstate.customerName = p0;
                      },
                    ),
                    10.getHightSizedBox,
                    MyTextFormField(
                      realEstate: realEstate,
                      textInputType: TextInputType.number,
                      initVal: realEstate.customerPhone,
                      labelText: "رقم الزبون",
                      onChanged: (p0) {
                        realEstate.customerPhone = p0;
                      },
                    ),
                    5.getHightSizedBox,
                    MyCheckBox(
                      isoffice: false,
                      val: realEstate.isOffice,
                      text: "مكتب",
                      onChanged: (p0) {
                        realEstate.isOffice = p0!;
                        setState(() {});
                      },
                    ),
                    5.getHightSizedBox,
                    if (realEstate.isOffice)
                      MyTextFormField(
                        realEstate: realEstate,
                        labelText: "اسم المكتب",
                        initVal: realEstate.officeName,
                        onChanged: (p0) {
                          realEstate.officeName = p0;
                        },
                      ),
                    if (realEstate.isOffice) 10.getHightSizedBox,
                    if (realEstate.isOffice)
                      MyTextFormField(
                        realEstate: realEstate,
                        textInputType: TextInputType.number,
                        labelText: "رقم المكتب",
                        initVal: realEstate.officePhone,
                        onChanged: (p0) {
                          realEstate.officePhone = p0;
                        },
                      ),
                    10.getHightSizedBox,
                    if (realEstate.type != Types.rent &&
                        realEstate.type != Types.buy)
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "معرض الصور",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                              10.getHightSizedBox,
                              EnhancedImageCompressor(
                                  isShow: false,
                                  realEstateId: realEstate.id.toString(),
                                  isEdit: true,
                                  onFilePicked: (List<File> files) {
                                    setState(() {
                                      _newlyPickedImages = files;
                                    });
                                  })
                            ],
                          ),
                        ),
                      ),

                    20.getHightSizedBox,

                    // ================== زر الحفظ ==================

                    Center(
                      child: _isLoading
                          ? CircularProgressIndicator(
                              backgroundColor: theme.canvasColor,
                            ) // عرض مؤشر التحميل أثناء العملية
                          : CustomTextButton(
                              onPressed: _addRealestate,
                              widget: const Icon(Icons.save_outlined),
                              text: "حفظ",
                              color: theme.cardColor,
                            ),
                    ),

                    50.getHightSizedBox,
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
