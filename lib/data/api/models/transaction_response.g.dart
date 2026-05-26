// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionResponseImpl _$$TransactionResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionResponseImpl(
  id: (json['id'] as num).toInt(),
  transactionDate: json['transaction_date'] as String,
  amountCents: (json['amount_cents'] as num).toInt(),
  isSettled: json['is_settled'] as bool,
  isCategoryManual: json['is_category_manual'] as bool,
  description: json['description'] as String?,
  transactionCode: json['transaction_code'] as String?,
  vendorName: json['vendor_name'] as String?,
  category: json['category'] as String?,
  sourceFile: json['source_file'] as String?,
);
