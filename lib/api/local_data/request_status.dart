import 'package:hive/hive.dart';
part 'request_status.g.dart';

@HiveType(typeId: 8)
enum RequestStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  complete,
  @HiveField(2)
  canceled;

  static RequestStatus getFromString(String string) {
    return switch (string.trim()) {
      "معلق" => RequestStatus.pending,
      "مكتمل" => RequestStatus.complete,
      "ملغى" => RequestStatus.canceled,
      _ => throw ArgumentError('Unknown request status string: $string'),
    };
  }

  String get arName {
    return switch (this) {
      pending => "معلق",
      complete => "مكتمل",
      canceled => "ملغى",
    };
  }
}
