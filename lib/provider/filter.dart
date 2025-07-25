import 'package:aqaraty/enums/enums.dart';
import 'package:aqaraty/local_data/condition.dart';
import 'package:aqaraty/local_data/direction.dart';
import 'package:aqaraty/local_data/furnishing_1.dart';
import 'package:aqaraty/local_data/property_type.dart';
import 'package:aqaraty/local_data/types_local.dart';
import 'package:aqaraty/models/filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterProvider =
    StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState());

  void updatePropertyTypes(List<PropertyType> types) {
    state = state.copyWith(selectedPropertyTypes: types);
  }

  void updateConditions(List<Condition> conditions) {
    state = state.copyWith(selectedConditions: conditions);
  }

  void updateFurnishings(List<Furnishing> furnishings) {
    state = state.copyWith(selectedFurnishings: furnishings);
  }

  void updateDirections(List<Direction> directions) {
    state = state.copyWith(selectedDirections: directions);
  }

  void updateTypes(List<Types> types) {
    state = state.copyWith(selectedTypes: types);
  }

  void updatePriceRange(int? min, int? max) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  void updateAreaRange(int? min, int? max) {
    state = state.copyWith(minArea: min, maxArea: max);
  }

  void updateRoomsRange(int? min, int? max) {
    state = state.copyWith(minRooms: min, maxRooms: max);
  }

  void updateWithSalon(bool? value) {
    state = state.copyWith(isWithSalon: value);
  }

  void updateWithSofa(bool? value) {
    state = state.copyWith(isWithSofa: value);
  }

  void updateIsOffice(bool? value) {
    state = state.copyWith(isOffice: value);
  }

  void resetFilters() {
    state = FilterState();
  }
}
