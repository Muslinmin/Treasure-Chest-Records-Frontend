import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';


// Immutable domain entity representing a single financial transaction.
// Money is stored as amountCents (int) — never as a float.
// Nullable fields reflect fields the backend may not populate yet.
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required DateTime transactionDate,
    required int amountCents,
    required bool isSettled,
    required bool isCategoryManual,
    String? description,
    String? transactionCode,
    String? vendorName,
    String? category,
    String? sourceFile,
  }) = _Transaction;
}