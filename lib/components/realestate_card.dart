import 'package:aqaraty/components/custom_image.dart';
import 'package:aqaraty/api/local_data/request_status.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/pages/info_page.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:aqaraty/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class RealEstateCard extends ConsumerStatefulWidget {
  const RealEstateCard({super.key, required this.realEstate});
  final RealEstate realEstate;

  @override
  ConsumerState<RealEstateCard> createState() => _RealEstateCardState();
}

class _RealEstateCardState extends ConsumerState<RealEstateCard> {
  Color _getStatusColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (widget.realEstate.requestStatus) {
      case RequestStatus.pending:
        return Colors.amber[600]!;
      case RequestStatus.complete:
        return Colors.teal[400]!;
      case RequestStatus.canceled:
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coreProv = ref.watch(coreProvider);
    final realEstate = coreProv.realEstates.firstWhere(
      (e) => e.id == widget.realEstate.id,
      orElse: () => widget.realEstate,
    );

    return GestureDetector(
      onTap: () => context.myPush(InfoPage(realEstate: realEstate)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xffD9D6D1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة العقار + الحالة
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  child: AspectRatio(
                    aspectRatio: 17 / 9,
                    child: CustomImage(
                      realEstate: realEstate,
                      path: realEstate.galleryImageIds?.firstOrNull,
                    ),
                  ),
                ),

                // تدرج غامق أسفل الصورة
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),

                // حالة الطلب
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getStatusColor(context),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      realEstate.requestStatus!.arName,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // تفاصيل العقار
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان والسعر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          realEstate.getRoomsWithExtra,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${NumberFormat.decimalPattern().format(realEstate.price ?? 0)} ${realEstate.currency?.symbol ?? ''}",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // الموقع
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          realEstate.locationArea ?? 'موقع غير محدد',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // مميزات إضافية
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _FeatureItem(
                          icon: Iconsax.ram,
                          value: realEstate.ownershipType?.arName ?? '',
                          label: 'ملكية',
                        ),
                        _FeatureItem(
                          icon: Iconsax.building,
                          value: realEstate.propertyType!.arName,
                          label: 'نوع العقار',
                        ),
                        _FeatureItem(
                          icon: Icons.aspect_ratio_outlined,
                          value: realEstate.area?.toString() ?? '0',
                          label: 'م²',
                        ),
                        _FeatureItem(
                          icon: Icons.apartment_outlined,
                          value: realEstate.getFloor ?? '-',
                          label: 'طابق',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // التاريخ + زر التفاصيل
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        realEstate.createdAt != null
                            ? 'أضيف: ${DateFormat('yyyy/M/d').format(realEstate.createdAt!)}'
                            : 'تاريخ غير معروف',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: theme.colorScheme.secondary,
                        ),
                        onPressed: () =>
                            context.myPush(InfoPage(realEstate: realEstate)),
                        child: Text(
                          'عرض التفاصيل',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _FeatureItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onPrimary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
