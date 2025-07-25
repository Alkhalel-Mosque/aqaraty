import 'package:aqaraty/enums/enums.dart';
import 'package:aqaraty/local_data/condition.dart';
import 'package:aqaraty/local_data/direction.dart';
import 'package:aqaraty/local_data/furnishing_1.dart';
import 'package:aqaraty/local_data/property_type.dart';
import 'package:aqaraty/local_data/types_local.dart';

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

  FilterState({
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
    bool? isWithSalon,
    bool? isWithSofa,
    bool? isOffice,
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
      isWithSalon: isWithSalon ?? this.isWithSalon,
      isWithSofa: isWithSofa ?? this.isWithSofa,
      isOffice: isOffice ?? this.isOffice,
    );
  }
}
