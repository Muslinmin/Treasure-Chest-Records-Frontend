// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'summary_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SummaryResponse _$SummaryResponseFromJson(Map<String, dynamic> json) {
  return _SummaryResponse.fromJson(json);
}

/// @nodoc
mixin _$SummaryResponse {
  String get period => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  int get totalCents => throw _privateConstructorUsedError;
  int get txCount => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SummaryResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SummaryResponseCopyWith<SummaryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SummaryResponseCopyWith<$Res> {
  factory $SummaryResponseCopyWith(
    SummaryResponse value,
    $Res Function(SummaryResponse) then,
  ) = _$SummaryResponseCopyWithImpl<$Res, SummaryResponse>;
  @useResult
  $Res call({
    String period,
    String category,
    int totalCents,
    int txCount,
    String updatedAt,
  });
}

/// @nodoc
class _$SummaryResponseCopyWithImpl<$Res, $Val extends SummaryResponse>
    implements $SummaryResponseCopyWith<$Res> {
  _$SummaryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? category = null,
    Object? totalCents = null,
    Object? txCount = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            totalCents: null == totalCents
                ? _value.totalCents
                : totalCents // ignore: cast_nullable_to_non_nullable
                      as int,
            txCount: null == txCount
                ? _value.txCount
                : txCount // ignore: cast_nullable_to_non_nullable
                      as int,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SummaryResponseImplCopyWith<$Res>
    implements $SummaryResponseCopyWith<$Res> {
  factory _$$SummaryResponseImplCopyWith(
    _$SummaryResponseImpl value,
    $Res Function(_$SummaryResponseImpl) then,
  ) = __$$SummaryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String period,
    String category,
    int totalCents,
    int txCount,
    String updatedAt,
  });
}

/// @nodoc
class __$$SummaryResponseImplCopyWithImpl<$Res>
    extends _$SummaryResponseCopyWithImpl<$Res, _$SummaryResponseImpl>
    implements _$$SummaryResponseImplCopyWith<$Res> {
  __$$SummaryResponseImplCopyWithImpl(
    _$SummaryResponseImpl _value,
    $Res Function(_$SummaryResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? category = null,
    Object? totalCents = null,
    Object? txCount = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$SummaryResponseImpl(
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        totalCents: null == totalCents
            ? _value.totalCents
            : totalCents // ignore: cast_nullable_to_non_nullable
                  as int,
        txCount: null == txCount
            ? _value.txCount
            : txCount // ignore: cast_nullable_to_non_nullable
                  as int,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SummaryResponseImpl extends _SummaryResponse {
  const _$SummaryResponseImpl({
    required this.period,
    required this.category,
    required this.totalCents,
    required this.txCount,
    required this.updatedAt,
  }) : super._();

  factory _$SummaryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SummaryResponseImplFromJson(json);

  @override
  final String period;
  @override
  final String category;
  @override
  final int totalCents;
  @override
  final int txCount;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'SummaryResponse(period: $period, category: $category, totalCents: $totalCents, txCount: $txCount, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SummaryResponseImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.totalCents, totalCents) ||
                other.totalCents == totalCents) &&
            (identical(other.txCount, txCount) || other.txCount == txCount) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    period,
    category,
    totalCents,
    txCount,
    updatedAt,
  );

  /// Create a copy of SummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SummaryResponseImplCopyWith<_$SummaryResponseImpl> get copyWith =>
      __$$SummaryResponseImplCopyWithImpl<_$SummaryResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SummaryResponseImplToJson(this);
  }
}

abstract class _SummaryResponse extends SummaryResponse {
  const factory _SummaryResponse({
    required final String period,
    required final String category,
    required final int totalCents,
    required final int txCount,
    required final String updatedAt,
  }) = _$SummaryResponseImpl;
  const _SummaryResponse._() : super._();

  factory _SummaryResponse.fromJson(Map<String, dynamic> json) =
      _$SummaryResponseImpl.fromJson;

  @override
  String get period;
  @override
  String get category;
  @override
  int get totalCents;
  @override
  int get txCount;
  @override
  String get updatedAt;

  /// Create a copy of SummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SummaryResponseImplCopyWith<_$SummaryResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
