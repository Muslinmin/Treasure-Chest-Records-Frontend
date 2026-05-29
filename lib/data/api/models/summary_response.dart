import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/summary.dart';

part 'summary_response.freezed.dart';
part 'summary_response.g.dart';

@freezed
class SummaryResponse with _$SummaryResponse {
  const SummaryResponse._();

  // Response-only model; createToJson must stay enabled so freezed's generated toJson() delegation compiles.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SummaryResponse({
    required String period,
    required String category,
    required int totalCents,
    required int txCount,
    required String updatedAt,
  }) = _SummaryResponse;

  factory SummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$SummaryResponseFromJson(json);

  Summary toDomain() {
    return Summary(
      period: period,
      category: category,
      totalCents: totalCents,
      txCount: txCount,
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}