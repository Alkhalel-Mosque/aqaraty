import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aqaraty/components/filter_button.dart';
import 'package:aqaraty/provider/filter.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/enums/enums.dart';

class FilterDrawer extends ConsumerStatefulWidget {
  final List<RealEstate> allEstates;
  final Function(List<RealEstate>) onFilterChanged;

  const FilterDrawer({
    super.key,
    required this.allEstates,
    required this.onFilterChanged,
  });

  @override
  FilterDrawerState createState() => FilterDrawerState();
}

class FilterDrawerState extends ConsumerState<FilterDrawer> {
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
    final filterState = ref.read(filterProvider);

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
          estate.price < filterState.minPrice!) {
        return false;
      }
      if (filterState.maxPrice != null &&
          estate.price > filterState.maxPrice!) {
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
          estate.rooms < filterState.minRooms!) {
        return false;
      }
      if (filterState.maxRooms != null &&
          estate.rooms > filterState.maxRooms!) {
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
              title: "نوع المعاملة",
              options: Types.values,
              selectedValues: filterState.selectedTypes,
              onChanged: (types) => filterNotifier.updateTypes(types),
              getLabel: (e) => e.arName,
            ),
            buildMultiSelect(
              title: "نوع العقار",
              options: PropertyType.values,
              selectedValues: filterState.selectedPropertyTypes,
              onChanged: (types) => filterNotifier.updatePropertyTypes(types),
              getLabel: (e) => e.arName,
            ),
            buildMultiSelect(
              title: "الحالة",
              options: Condition.values,
              selectedValues: filterState.selectedConditions,
              onChanged: (conditions) =>
                  filterNotifier.updateConditions(conditions),
              getLabel: (e) => e.arName,
            ),
            buildMultiSelect(
              title: "الفرش",
              options: Furnishing.values,
              selectedValues: filterState.selectedFurnishings,
              onChanged: (furnishings) =>
                  filterNotifier.updateFurnishings(furnishings),
              getLabel: (e) => e.arName,
            ),
            buildMultiSelect(
              title: "الاتجاه",
              options: Direction.values,
              selectedValues: filterState.selectedDirections,
              onChanged: (directions) =>
                  filterNotifier.updateDirections(directions),
              getLabel: (e) => e.arName,
            ),
            const SizedBox(height: 10),
            buildRangeInput("السعر", minPriceController, maxPriceController),
            buildRangeInput("المساحة", minAreaController, maxAreaController),
            buildRangeInput(
                "عدد الغرف", minRoomsController, maxRoomsController),
            buildBooleanDropdown("صالون", filterState.isWithSalon,
                (val) => filterNotifier.updateWithSalon(val)),
            buildBooleanDropdown("صوفا", filterState.isWithSofa,
                (val) => filterNotifier.updateWithSofa(val)),
            buildBooleanDropdown("مكتب", filterState.isOffice,
                (val) => filterNotifier.updateIsOffice(val)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: applyFilters,
              child: const Text("تطبيق الفلاتر"),
            ),
            TextButton(
              onPressed: () {
                filterNotifier.resetFilters();
                widget.onFilterChanged(widget.allEstates);
              },
              child: const Text("إعادة تعيين الفلاتر"),
            ),
          ],
        ),
      ),
    );
  }
}
