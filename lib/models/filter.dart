import 'package:aqaraty/api/local_data/condition.dart';
import 'package:aqaraty/api/local_data/currency2.dart';
import 'package:aqaraty/api/local_data/direction.dart';
import 'package:aqaraty/api/local_data/furnishing.dart';
import 'package:aqaraty/api/local_data/property_type.dart';
import 'package:aqaraty/api/local_data/types_local.dart';

import 'real_estate.dart';

class FilterState {
  final List<PropertyType> selectedPropertyTypes;
  final List<Condition> selectedConditions;
  final List<Furnishing> selectedFurnishings;
  final List<Direction> selectedDirections;
  final List<Types> selectedTypes;

  final int? minPrice;
  final int? maxPrice;
  final int? minArea;
  final int? maxArea;
  final int? minRooms;
  final int? maxRooms;

  final bool? isWithSalon;
  final bool? isWithSofa;
  final bool? isOffice;

  final Currency? currency;

  const FilterState({
    this.selectedPropertyTypes = const [],
    this.selectedConditions = const [],
    this.selectedFurnishings = const [],
    this.selectedDirections = const [],
    this.selectedTypes = const [],
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    this.minRooms,
    this.maxRooms,
    this.isWithSalon,
    this.isWithSofa,
    this.isOffice,
    this.currency,
  });

  FilterState copyWith({
    List<PropertyType>? selectedPropertyTypes,
    List<Condition>? selectedConditions,
    List<Furnishing>? selectedFurnishings,
    List<Direction>? selectedDirections,
    List<Types>? selectedTypes,
    int? minPrice,
    int? maxPrice,
    int? minArea,
    int? maxArea,
    int? minRooms,
    int? maxRooms,
    dynamic isWithSalon = unset,
    dynamic isWithSofa = unset,
    dynamic isOffice = unset,
    Currency? currency,
  }) {
    return FilterState(
      selectedPropertyTypes:
          selectedPropertyTypes ?? this.selectedPropertyTypes,
      selectedConditions: selectedConditions ?? this.selectedConditions,
      selectedFurnishings: selectedFurnishings ?? this.selectedFurnishings,
      selectedDirections: selectedDirections ?? this.selectedDirections,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minArea: minArea ?? this.minArea,
      maxArea: maxArea ?? this.maxArea,
      minRooms: minRooms ?? this.minRooms,
      maxRooms: maxRooms ?? this.maxRooms,
      isWithSalon:
          isWithSalon is Unset ? this.isWithSalon : isWithSalon as bool?,
      isWithSofa: isWithSofa is Unset ? this.isWithSofa : isWithSofa as bool?,
      isOffice: isOffice is Unset ? this.isOffice : isOffice as bool?,
      currency: currency ?? this.currency,
    );
  }
}
