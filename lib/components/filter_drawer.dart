import 'package:aqaraty/api/local_data/condition.dart';
import 'package:aqaraty/api/local_data/currency2.dart';
import 'package:aqaraty/api/local_data/direction.dart';
import 'package:aqaraty/api/local_data/furnishing.dart';
import 'package:aqaraty/api/local_data/property_type.dart';
import 'package:aqaraty/api/local_data/types_local.dart';
import 'package:aqaraty/extensions/extension.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aqaraty/components/filter_button.dart';
import 'package:aqaraty/provider/filter.dart';
import 'package:aqaraty/models/real_estate.dart';

class FilterDrawer extends ConsumerStatefulWidget {
  final List<RealEstate> allEstates;
  final Function(List<RealEstate>) onFilterChanged;

  const FilterDrawer({
    super.key,
    required this.allEstates,
    required this.onFilterChanged,
  });

  @override
  ConsumerState<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends ConsumerState<FilterDrawer> {
  late TextEditingController minPriceController;
  late TextEditingController maxPriceController;
  late TextEditingController minAreaController;
  late TextEditingController maxAreaController;
  late TextEditingController minRoomsController;
  late TextEditingController maxRoomsController;

  @override
  void initState() {
    super.initState();

    final filterState = ref.read(filterProvider);
    minPriceController =
        TextEditingController(text: filterState.minPrice?.toString() ?? '');
    maxPriceController =
        TextEditingController(text: filterState.maxPrice?.toString() ?? '');
    minAreaController =
        TextEditingController(text: filterState.minArea?.toString() ?? '');
    maxAreaController =
        TextEditingController(text: filterState.maxArea?.toString() ?? '');
    minRoomsController =
        TextEditingController(text: filterState.minRooms?.toString() ?? '');
    maxRoomsController =
        TextEditingController(text: filterState.maxRooms?.toString() ?? '');
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    minAreaController.dispose();
    maxAreaController.dispose();
    minRoomsController.dispose();
    maxRoomsController.dispose();
    super.dispose();
  }

  void applyFilters() {
    final filterNotifier = ref.read(filterProvider.notifier);

    final minPrice = int.tryParse(minPriceController.text);
    final maxPrice = int.tryParse(maxPriceController.text);
    final minArea = int.tryParse(minAreaController.text);
    final maxArea = int.tryParse(maxAreaController.text);
    final minRooms = int.tryParse(minRoomsController.text);
    final maxRooms = int.tryParse(maxRoomsController.text);

    filterNotifier.updatePriceRange(minPrice, maxPrice);
    filterNotifier.updateAreaRange(minArea, maxArea);
    filterNotifier.updateRoomsRange(minRooms, maxRooms);

    final filtered = widget.allEstates.where((estate) {
      final filterState = ref.read(filterProvider);
      final core = ref.read(coreProvider);
      final estatePriceInFilterCurrency = core.convertPrice(
        estate.price,
        estate.currency,
        filterState.currency ?? Currency.SYP,
      );

      if (filterState.selectedTypes.isNotEmpty &&
          !filterState.selectedTypes.contains(estate.type)) {
        return false;
      }
      if (filterState.selectedPropertyTypes.isNotEmpty &&
          !filterState.selectedPropertyTypes.contains(estate.propertyType)) {
        return false;
      }
      if (filterState.selectedConditions.isNotEmpty &&
          !filterState.selectedConditions.contains(estate.condition)) {
        return false;
      }
      if (filterState.selectedFurnishings.isNotEmpty &&
          !filterState.selectedFurnishings.contains(estate.furnishing)) {
        return false;
      }
      if (filterState.selectedDirections.isNotEmpty &&
          !filterState.selectedDirections.contains(estate.direction)) {
        return false;
      }

      if (filterState.minPrice != null &&
          estatePriceInFilterCurrency != null &&
          estatePriceInFilterCurrency < filterState.minPrice!) {
        return false;
      }
      if (filterState.maxPrice != null &&
          estatePriceInFilterCurrency != null &&
          estatePriceInFilterCurrency > filterState.maxPrice!) {
        return false;
      }

      if (filterState.minArea != null &&
          (estate.area ?? 0) < filterState.minArea!) {
        return false;
      }
      if (filterState.maxArea != null &&
          (estate.area ?? 0) > filterState.maxArea!) {
        return false;
      }

      if (filterState.minRooms != null &&
          (estate.rooms ?? 0) < filterState.minRooms!) {
        return false;
      }
      if (filterState.maxRooms != null &&
          (estate.rooms ?? 0) > filterState.maxRooms!) {
        return false;
      }

      if (filterState.isWithSalon != null &&
          estate.iswithSalon != filterState.isWithSalon) {
        return false;
      }
      if (filterState.isWithSofa != null &&
          estate.iswithSofa != filterState.isWithSofa) {
        return false;
      }
      if (filterState.isOffice != null &&
          estate.isOffice != filterState.isOffice) {
        return false;
      }

      return true;
    }).toList();

    widget.onFilterChanged(filtered);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filterState = ref.watch(filterProvider);
    final filterNotifier = ref.read(filterProvider.notifier);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text("فلترة العقارات",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            buildMultiSelect(
              ctx: context,
              title: "نوع المعاملة",
              options: Types.values,
              selectedValues: filterState.selectedTypes,
              onChanged: (types) => filterNotifier.updateTypes(types),
              getLabel: (e) => e.arName,
            ),
            buildMultiSelect(
              ctx: context,
              title: "نوع العقار",
              options: PropertyType.values,
              selectedValues: filterState.selectedPropertyTypes,
              onChanged: (types) => filterNotifier.updatePropertyTypes(types),
              getLabel: (e) => e.arName,
            ),
            buildMultiSelect(
              ctx: context,
              title: "الإكساء",
              options: Condition.values,
              selectedValues: filterState.selectedConditions,
              onChanged: (conditions) =>
                  filterNotifier.updateConditions(conditions),
              getLabel: (e) => e.arName,
            ),
            buildMultiSelect(
              ctx: context,
              title: "الفرش",
              options: Furnishing.values,
              selectedValues: filterState.selectedFurnishings,
              onChanged: (furnishings) =>
                  filterNotifier.updateFurnishings(furnishings),
              getLabel: (e) => e.arName,
            ),
            buildMultiSelect(
              ctx: context,
              title: "الاتجاه",
              options: Direction.values,
              selectedValues: filterState.selectedDirections,
              onChanged: (directions) =>
                  filterNotifier.updateDirections(directions),
              getLabel: (e) => e.arName,
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "اختر العملة:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16, // المسافة الأفقية بين العناصر
                  children: Currency.values.map((c) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<Currency>(
                          activeColor: theme.focusColor,
                          value: c,
                          groupValue: filterState.currency ?? Currency.USD,
                          onChanged: (val) {
                            filterNotifier.updateCurrency(val);
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text(c.symbol, style: const TextStyle(fontSize: 14)),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
            10.getHightSizedBox,
            buildRangeInput(
                "السعر", minPriceController, maxPriceController, context),
            5.getHightSizedBox,
            buildRangeInput(
                "المساحة", minAreaController, maxAreaController, context),
            5.getHightSizedBox,
            buildRangeInput(
                "عدد الغرف", minRoomsController, maxRoomsController, context),
            5.getHightSizedBox,
            buildBooleanDropdown(context, "صالون", filterState.isWithSalon,
                (val) => filterNotifier.updateWithSalon(val)),
            buildBooleanDropdown(context, "صوفا", filterState.isWithSofa,
                (val) => filterNotifier.updateWithSofa(val)),
            buildBooleanDropdown(context, "مكتب", filterState.isOffice,
                (val) => filterNotifier.updateIsOffice(val)),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(theme.focusColor)),
              onPressed: applyFilters,
              child: const Text("تطبيق الفلاتر"),
            ),
            TextButton(
              onPressed: () {
                filterNotifier.resetFilters();
                widget.onFilterChanged(widget.allEstates);
              },
              child: const Text(
                "إعادة تعيين الفلاتر",
                style: TextStyle(color: Color.fromARGB(213, 246, 83, 71)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
