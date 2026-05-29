// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SummaryResponseImpl _$$SummaryResponseImplFromJson(
  Map<String, dynamic> json,
) => _$SummaryResponseImpl(
  period: json['period'] as String,
  category: json['category'] as String,
  totalCents: (json['total_cents'] as num).toInt(),
  txCount: (json['tx_count'] as num).toInt(),
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$$SummaryResponseImplToJson(
  _$SummaryResponseImpl instance,
) => <String, dynamic>{
  'period': instance.period,
  'category': instance.category,
  'total_cents': instance.totalCents,
  'tx_count': instance.txCount,
  'updated_at': instance.updatedAt,
};
