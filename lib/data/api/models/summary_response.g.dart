// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummaryResponse _$SummaryResponseFromJson(Map<String, dynamic> json) =>
    SummaryResponse(
      period: json['period'] as String,
      category: json['category'] as String,
      totalCents: (json['total_cents'] as num).toInt(),
      txCount: (json['tx_count'] as num).toInt(),
      updatedAt: json['updated_at'] as String,
    );

_$SummaryResponseImpl _$$SummaryResponseImplFromJson(
  Map<String, dynamic> json,
) => _$SummaryResponseImpl(
  period: json['period'] as String,
  category: json['category'] as String,
  totalCents: (json['totalCents'] as num).toInt(),
  txCount: (json['txCount'] as num).toInt(),
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$$SummaryResponseImplToJson(
  _$SummaryResponseImpl instance,
) => <String, dynamic>{
  'period': instance.period,
  'category': instance.category,
  'totalCents': instance.totalCents,
  'txCount': instance.txCount,
  'updatedAt': instance.updatedAt,
};
