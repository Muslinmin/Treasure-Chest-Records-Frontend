// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    TransactionResponse(
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

_$TransactionResponseImpl _$$TransactionResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionResponseImpl(
  id: (json['id'] as num).toInt(),
  transactionDate: json['transactionDate'] as String,
  amountCents: (json['amountCents'] as num).toInt(),
  isSettled: json['isSettled'] as bool,
  isCategoryManual: json['isCategoryManual'] as bool,
  description: json['description'] as String?,
  transactionCode: json['transactionCode'] as String?,
  vendorName: json['vendorName'] as String?,
  category: json['category'] as String?,
  sourceFile: json['sourceFile'] as String?,
);

Map<String, dynamic> _$$TransactionResponseImplToJson(
  _$TransactionResponseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'transactionDate': instance.transactionDate,
  'amountCents': instance.amountCents,
  'isSettled': instance.isSettled,
  'isCategoryManual': instance.isCategoryManual,
  'description': instance.description,
  'transactionCode': instance.transactionCode,
  'vendorName': instance.vendorName,
  'category': instance.category,
  'sourceFile': instance.sourceFile,
};
