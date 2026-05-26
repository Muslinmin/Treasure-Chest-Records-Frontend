import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/summary.dart';

part 'summary_response.freezed.dart';
part 'summary_response.g.dart';

@freezed
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class SummaryResponse with _$SummaryResponse {
  const SummaryResponse._();

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