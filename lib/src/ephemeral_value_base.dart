// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

/// Ephemeral values are used to represent the state of a value that can change over time.
///
/// They are useful for representing the state of a value that can be `None`, `Initial`, `Loading`, `Success`, `Error`, or `Empty`.
abstract class Ephemeral<T> {
  const Ephemeral();

  T? get value;

  /// Changes the current state to `NoneValue`.
  ///
  /// If you don't provide a value, the state will change retaining the current value.
  ///
  /// If you want to force a new value, use the class constructor `NoneValue(...)` instead.
  NoneValue<T> toNone([T? value]) => NoneValue<T>(value ?? this.value);

  /// Changes the current state to `InitialValue`.
  ///
  /// If you don't provide a value, the state will change retaining the current value. If the current value is null, it will throw an assertion error.
  ///
  /// If you want to force a new value, use the class constructor `InitialValue(...)` instead.
  InitialValue<T> toInitial([T? value, String? message]) {
    final v = value ?? this.value;
    assert(v != null, 'ephemeral_value (library): InitialValue cannot be created with a null value');
    return InitialValue<T>(v as T, message);
  }

  /// Changes the current state to `LoadingValue`.
  ///
  /// If you don't provide a value, the state will change retaining the current value.
  ///
  /// If you want to force a new value, use the class constructor `LoadingValue(...)` instead.
  LoadingValue<T> toLoading([T? value, String? message]) {
    return LoadingValue<T>(value ?? this.value, message);
  }

  /// Changes the current state to `SuccessValue`.
  ///
  /// If you don't provide a value, the state will change retaining the current value.
  ///
  /// If you want to force a new value, use the class constructor `SuccessValue(...)` instead.
  SuccessValue<T> toSuccess([T? value, String? message]) {
    final v = value ?? this.value;
    assert(v != null, 'ephemeral_value (library): SuccessValue cannot be created with a null value');
    return SuccessValue<T>(v as T, message);
  }

  /// Changes the current state to `ErrorValue`.
  ///
  /// If you don't provide a value, the state will change retaining the current value.
  ///
  /// If you want to force a new value, use the class constructor `ErrorValue(...)` instead.
  ErrorValue<T> toError([T? value, Object? error]) {
    return ErrorValue<T>(value ?? this.value, error);
  }

  /// Changes the current state to `EmptyValue`.
  ///
  /// If you don't provide a value, the state will change retaining the current value.
  ///
  /// If you want to force a new value, use the class constructor `EmptyValue(...)` instead.
  EmptyValue<T> toEmpty([T? value, String? message]) {
    return EmptyValue<T>(value ?? this.value, message);
  }
}

/// Use to intialize a nullable value.
///
/// [value] can be null.
class NoneValue<T> extends Ephemeral<T> with EquatableMixin {
  @override
  final T? value;

  const NoneValue(this.value);

  @override
  String toString() => 'NoneValue(value: $value)';

  @override
  List<Object?> get props => [value];
}

/// Use to initialize a non-nullable value.
///
/// [value] must not be null.
class InitialValue<T> extends Ephemeral<T> with EquatableMixin {
  @override
  final T value;
  final String? message;

  const InitialValue(this.value, [this.message]);

  @override
  String toString() => 'InitialValue(value: $value, message: $message)';

  @override
  List<Object?> get props => [value, message];
}

/// A state indicating that the value is currently being loaded.
class LoadingValue<T> extends Ephemeral<T> with EquatableMixin {
  @override
  final T? value;
  final String? message;

  const LoadingValue([this.value, this.message]);

  @override
  String toString() => 'LoadingValue(value: $value, message: $message)';

  @override
  List<Object?> get props => [value, message];
}

/// A state indicating that the value has been successfully loaded.
class SuccessValue<T> extends Ephemeral<T> with EquatableMixin {
  @override
  final T value;
  final String? message;

  const SuccessValue(this.value, [this.message]);

  @override
  String toString() => 'SuccessValue(value: $value, message: $message)';

  @override
  List<Object?> get props => [value, message];
}

/// A state indicating that an error occurred while loading the value.
class ErrorValue<T> extends Ephemeral<T> with EquatableMixin {
  @override
  final T? value;
  final Object? error;

  const ErrorValue([this.value, this.error]);

  @override
  String toString() => 'ErrorValue(value: $value, error: $error)';

  @override
  List<Object?> get props => [value, error];
}

/// A state indicating that it's successfully loaded but the value is just empty or null.
///
/// If unsure, just use [SuccessValue] instead.
class EmptyValue<T> extends Ephemeral<T> with EquatableMixin {
  @override
  final T? value;
  final String? message;

  const EmptyValue([this.value, this.message]);

  @override
  String toString() => 'EmptyValue(value: $value, message: $message)';

  @override
  List<Object?> get props => [value, message];
}
