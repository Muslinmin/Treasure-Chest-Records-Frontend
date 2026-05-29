// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) {
  return _TransactionResponse.fromJson(json);
}

/// @nodoc
mixin _$TransactionResponse {
  int get id => throw _privateConstructorUsedError;
  String get transactionDate => throw _privateConstructorUsedError;
  int get amountCents => throw _privateConstructorUsedError;
  bool get isSettled => throw _privateConstructorUsedError;
  bool get isCategoryManual => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get transactionCode => throw _privateConstructorUsedError;
  String? get vendorName => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get sourceFile => throw _privateConstructorUsedError;

  /// Serializes this TransactionResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionResponseCopyWith<TransactionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionResponseCopyWith<$Res> {
  factory $TransactionResponseCopyWith(
    TransactionResponse value,
    $Res Function(TransactionResponse) then,
  ) = _$TransactionResponseCopyWithImpl<$Res, TransactionResponse>;
  @useResult
  $Res call({
    int id,
    String transactionDate,
    int amountCents,
    bool isSettled,
    bool isCategoryManual,
    String? description,
    String? transactionCode,
    String? vendorName,
    String? category,
    String? sourceFile,
  });
}

/// @nodoc
class _$TransactionResponseCopyWithImpl<$Res, $Val extends TransactionResponse>
    implements $TransactionResponseCopyWith<$Res> {
  _$TransactionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionDate = null,
    Object? amountCents = null,
    Object? isSettled = null,
    Object? isCategoryManual = null,
    Object? description = freezed,
    Object? transactionCode = freezed,
    Object? vendorName = freezed,
    Object? category = freezed,
    Object? sourceFile = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            transactionDate: null == transactionDate
                ? _value.transactionDate
                : transactionDate // ignore: cast_nullable_to_non_nullable
                      as String,
            amountCents: null == amountCents
                ? _value.amountCents
                : amountCents // ignore: cast_nullable_to_non_nullable
                      as int,
            isSettled: null == isSettled
                ? _value.isSettled
                : isSettled // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCategoryManual: null == isCategoryManual
                ? _value.isCategoryManual
                : isCategoryManual // ignore: cast_nullable_to_non_nullable
                      as bool,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            transactionCode: freezed == transactionCode
                ? _value.transactionCode
                : transactionCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            vendorName: freezed == vendorName
                ? _value.vendorName
                : vendorName // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            sourceFile: freezed == sourceFile
                ? _value.sourceFile
                : sourceFile // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionResponseImplCopyWith<$Res>
    implements $TransactionResponseCopyWith<$Res> {
  factory _$$TransactionResponseImplCopyWith(
    _$TransactionResponseImpl value,
    $Res Function(_$TransactionResponseImpl) then,
  ) = __$$TransactionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String transactionDate,
    int amountCents,
    bool isSettled,
    bool isCategoryManual,
    String? description,
    String? transactionCode,
    String? vendorName,
    String? category,
    String? sourceFile,
  });
}

/// @nodoc
class __$$TransactionResponseImplCopyWithImpl<$Res>
    extends _$TransactionResponseCopyWithImpl<$Res, _$TransactionResponseImpl>
    implements _$$TransactionResponseImplCopyWith<$Res> {
  __$$TransactionResponseImplCopyWithImpl(
    _$TransactionResponseImpl _value,
    $Res Function(_$TransactionResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionDate = null,
    Object? amountCents = null,
    Object? isSettled = null,
    Object? isCategoryManual = null,
    Object? description = freezed,
    Object? transactionCode = freezed,
    Object? vendorName = freezed,
    Object? category = freezed,
    Object? sourceFile = freezed,
  }) {
    return _then(
      _$TransactionResponseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        transactionDate: null == transactionDate
            ? _value.transactionDate
            : transactionDate // ignore: cast_nullable_to_non_nullable
                  as String,
        amountCents: null == amountCents
            ? _value.amountCents
            : amountCents // ignore: cast_nullable_to_non_nullable
                  as int,
        isSettled: null == isSettled
            ? _value.isSettled
            : isSettled // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCategoryManual: null == isCategoryManual
            ? _value.isCategoryManual
            : isCategoryManual // ignore: cast_nullable_to_non_nullable
                  as bool,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        transactionCode: freezed == transactionCode
            ? _value.transactionCode
            : transactionCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        vendorName: freezed == vendorName
            ? _value.vendorName
            : vendorName // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        sourceFile: freezed == sourceFile
            ? _value.sourceFile
            : sourceFile // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$TransactionResponseImpl extends _TransactionResponse {
  const _$TransactionResponseImpl({
    required this.id,
    required this.transactionDate,
    required this.amountCents,
    required this.isSettled,
    required this.isCategoryManual,
    this.description,
    this.transactionCode,
    this.vendorName,
    this.category,
    this.sourceFile,
  }) : super._();

  factory _$TransactionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionResponseImplFromJson(json);

  @override
  final int id;
  @override
  final String transactionDate;
  @override
  final int amountCents;
  @override
  final bool isSettled;
  @override
  final bool isCategoryManual;
  @override
  final String? description;
  @override
  final String? transactionCode;
  @override
  final String? vendorName;
  @override
  final String? category;
  @override
  final String? sourceFile;

  @override
  String toString() {
    return 'TransactionResponse(id: $id, transactionDate: $transactionDate, amountCents: $amountCents, isSettled: $isSettled, isCategoryManual: $isCategoryManual, description: $description, transactionCode: $transactionCode, vendorName: $vendorName, category: $category, sourceFile: $sourceFile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.isSettled, isSettled) ||
                other.isSettled == isSettled) &&
            (identical(other.isCategoryManual, isCategoryManual) ||
                other.isCategoryManual == isCategoryManual) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.transactionCode, transactionCode) ||
                other.transactionCode == transactionCode) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.sourceFile, sourceFile) ||
                other.sourceFile == sourceFile));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    transactionDate,
    amountCents,
    isSettled,
    isCategoryManual,
    description,
    transactionCode,
    vendorName,
    category,
    sourceFile,
  );

  /// Create a copy of TransactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionResponseImplCopyWith<_$TransactionResponseImpl> get copyWith =>
      __$$TransactionResponseImplCopyWithImpl<_$TransactionResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionResponseImplToJson(this);
  }
}

abstract class _TransactionResponse extends TransactionResponse {
  const factory _TransactionResponse({
    required final int id,
    required final String transactionDate,
    required final int amountCents,
    required final bool isSettled,
    required final bool isCategoryManual,
    final String? description,
    final String? transactionCode,
    final String? vendorName,
    final String? category,
    final String? sourceFile,
  }) = _$TransactionResponseImpl;
  const _TransactionResponse._() : super._();

  factory _TransactionResponse.fromJson(Map<String, dynamic> json) =
      _$TransactionResponseImpl.fromJson;

  @override
  int get id;
  @override
  String get transactionDate;
  @override
  int get amountCents;
  @override
  bool get isSettled;
  @override
  bool get isCategoryManual;
  @override
  String? get description;
  @override
  String? get transactionCode;
  @override
  String? get vendorName;
  @override
  String? get category;
  @override
  String? get sourceFile;

  /// Create a copy of TransactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionResponseImplCopyWith<_$TransactionResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
