// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'camera_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CameraState {
  bool get hasPermission => throw _privateConstructorUsedError;
  bool get isInitialized => throw _privateConstructorUsedError;
  CameraFlashMode get flashMode => throw _privateConstructorUsedError;
  CameraLensDirection get lensDirection => throw _privateConstructorUsedError;
  CameraError? get error => throw _privateConstructorUsedError;

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CameraStateCopyWith<CameraState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CameraStateCopyWith<$Res> {
  factory $CameraStateCopyWith(
          CameraState value, $Res Function(CameraState) then) =
      _$CameraStateCopyWithImpl<$Res, CameraState>;
  @useResult
  $Res call(
      {bool hasPermission,
      bool isInitialized,
      CameraFlashMode flashMode,
      CameraLensDirection lensDirection,
      CameraError? error});
}

/// @nodoc
class _$CameraStateCopyWithImpl<$Res, $Val extends CameraState>
    implements $CameraStateCopyWith<$Res> {
  _$CameraStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasPermission = null,
    Object? isInitialized = null,
    Object? flashMode = null,
    Object? lensDirection = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      hasPermission: null == hasPermission
          ? _value.hasPermission
          : hasPermission // ignore: cast_nullable_to_non_nullable
              as bool,
      isInitialized: null == isInitialized
          ? _value.isInitialized
          : isInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      flashMode: null == flashMode
          ? _value.flashMode
          : flashMode // ignore: cast_nullable_to_non_nullable
              as CameraFlashMode,
      lensDirection: null == lensDirection
          ? _value.lensDirection
          : lensDirection // ignore: cast_nullable_to_non_nullable
              as CameraLensDirection,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as CameraError?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CameraStateImplCopyWith<$Res>
    implements $CameraStateCopyWith<$Res> {
  factory _$$CameraStateImplCopyWith(
          _$CameraStateImpl value, $Res Function(_$CameraStateImpl) then) =
      __$$CameraStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool hasPermission,
      bool isInitialized,
      CameraFlashMode flashMode,
      CameraLensDirection lensDirection,
      CameraError? error});
}

/// @nodoc
class __$$CameraStateImplCopyWithImpl<$Res>
    extends _$CameraStateCopyWithImpl<$Res, _$CameraStateImpl>
    implements _$$CameraStateImplCopyWith<$Res> {
  __$$CameraStateImplCopyWithImpl(
      _$CameraStateImpl _value, $Res Function(_$CameraStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasPermission = null,
    Object? isInitialized = null,
    Object? flashMode = null,
    Object? lensDirection = null,
    Object? error = freezed,
  }) {
    return _then(_$CameraStateImpl(
      hasPermission: null == hasPermission
          ? _value.hasPermission
          : hasPermission // ignore: cast_nullable_to_non_nullable
              as bool,
      isInitialized: null == isInitialized
          ? _value.isInitialized
          : isInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      flashMode: null == flashMode
          ? _value.flashMode
          : flashMode // ignore: cast_nullable_to_non_nullable
              as CameraFlashMode,
      lensDirection: null == lensDirection
          ? _value.lensDirection
          : lensDirection // ignore: cast_nullable_to_non_nullable
              as CameraLensDirection,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as CameraError?,
    ));
  }
}

/// @nodoc

class _$CameraStateImpl implements _CameraState {
  const _$CameraStateImpl(
      {this.hasPermission = false,
      this.isInitialized = false,
      this.flashMode = CameraFlashMode.auto,
      this.lensDirection = CameraLensDirection.back,
      this.error});

  @override
  @JsonKey()
  final bool hasPermission;
  @override
  @JsonKey()
  final bool isInitialized;
  @override
  @JsonKey()
  final CameraFlashMode flashMode;
  @override
  @JsonKey()
  final CameraLensDirection lensDirection;
  @override
  final CameraError? error;

  @override
  String toString() {
    return 'CameraState(hasPermission: $hasPermission, isInitialized: $isInitialized, flashMode: $flashMode, lensDirection: $lensDirection, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CameraStateImpl &&
            (identical(other.hasPermission, hasPermission) ||
                other.hasPermission == hasPermission) &&
            (identical(other.isInitialized, isInitialized) ||
                other.isInitialized == isInitialized) &&
            (identical(other.flashMode, flashMode) ||
                other.flashMode == flashMode) &&
            (identical(other.lensDirection, lensDirection) ||
                other.lensDirection == lensDirection) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hasPermission, isInitialized,
      flashMode, lensDirection, error);

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CameraStateImplCopyWith<_$CameraStateImpl> get copyWith =>
      __$$CameraStateImplCopyWithImpl<_$CameraStateImpl>(this, _$identity);
}

abstract class _CameraState implements CameraState {
  const factory _CameraState(
      {final bool hasPermission,
      final bool isInitialized,
      final CameraFlashMode flashMode,
      final CameraLensDirection lensDirection,
      final CameraError? error}) = _$CameraStateImpl;

  @override
  bool get hasPermission;
  @override
  bool get isInitialized;
  @override
  CameraFlashMode get flashMode;
  @override
  CameraLensDirection get lensDirection;
  @override
  CameraError? get error;

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CameraStateImplCopyWith<_$CameraStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
