import 'package:freezed_annotation/freezed_annotation.dart';

part 'summary.freezed.dart';

// Immutable domain entity representing a spending summary bucket.
// One bucket = one period + one category. Money stored as totalCents (int).
@freezed
class Summary with _$Summary {
  const factory Summary({
    required String period,
    required String category,
    required int totalCents,
    required int txCount,
    required DateTime updatedAt,
  }) = _Summary;
}