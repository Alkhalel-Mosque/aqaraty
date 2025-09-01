import 'package:aqaraty/api/local_data/property_type.dart';
import 'package:aqaraty/api/local_data/request_status.dart';
import 'package:aqaraty/api/local_data/types_local.dart';
import 'package:aqaraty/extensions/extension.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:aqaraty/widgets/my_compobox.dart';
import 'package:aqaraty/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalInfo extends ConsumerStatefulWidget {
  final RealEstate realEstate;
  final ValueChanged<String?>? onTypeChanged; // 👈 جديد

  const PersonalInfo({
    super.key,
    required this.realEstate,
    this.onTypeChanged,
  });

  @override
  ConsumerState<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends ConsumerState<PersonalInfo> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("المعلومات الأساسية",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.outline,
                )),
            10.getHightSizedBox,
            if (widget.realEstate.createdById != null)
              MyTextFormField(
                realEstate: widget.realEstate,
                labelText: "منشئ الطلب",
                enabled: false,
                suffixIcon: const Icon(Icons.account_circle_outlined),
                initVal: ref.read(coreProvider).user?.username,
              ),
            10.getHightSizedBox,
            Row(
              children: [
                Expanded(
                  child: MyComboBox(
                    text: widget.realEstate.requestStatus?.arName,
                    hint: "الحالة",
                    items: RequestStatus.values.map((e) => e.arName).toList(),
                    onChanged: (p0) {
                      widget.realEstate.requestStatus =
                          RequestStatus.getFromString(p0!);
                      setState(() {});
                    },
                  ),
                ),
                10.getWidthSizedBox,
                Expanded(
                  child: MyComboBox(
                    text: widget.realEstate.type?.arNameTitle,
                    hint: "نوع الإضافة",
                    items: Types.values.map((e) => e.arNameTitle).toList(),
                    onChanged: (p0) {
                      widget.realEstate.type = Types.getFromString(p0!);
                      setState(() {});
                      widget.onTypeChanged?.call(p0); // 👈 استدعاء الكول باك
                    },
                  ),
                ),
              ],
            ),
            10.getHightSizedBox,
            MyComboBox(
              hint: "نوع العقار",
              text: widget.realEstate.propertyType?.arName,
              onChanged: (p0) {
                widget.realEstate.propertyType =
                    PropertyType.getFromString(p0!);
                setState(() {});
              },
              items: PropertyType.values.map((e) => e.arName).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
