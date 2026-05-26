import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/transaction.dart';

part 'transaction_response.freezed.dart';
part 'transaction_response.g.dart';

@freezed
class TransactionResponse with _$TransactionResponse {
  const TransactionResponse._();

  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory TransactionResponse({
    required int id,
    required String transactionDate,
    required int amountCents,
    required bool isSettled,
    required bool isCategoryManual,
    String? description,
    String? transactionCode,
    String? vendorName,
    String? category,
    String? sourceFile,
  }) = _TransactionResponse;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  Transaction toDomain() {
    return Transaction(
      id: id,
      transactionDate: DateTime.parse(transactionDate),
      amountCents: amountCents,
      isSettled: isSettled,
      isCategoryManual: isCategoryManual,
      description: description,
      transactionCode: transactionCode,
      vendorName: vendorName,
      category: category,
      sourceFile: sourceFile,
    );
  }
}