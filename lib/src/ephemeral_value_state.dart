import 'package:equatable/equatable.dart';

import 'index.dart';

/// Use to intialize a nullable value.
///
/// [value] can be null.
class NoneValue<T> extends Ephemeral<T> with EquatableMixin {
  @override
  final T? value;

  const NoneValue([this.value]);

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

/// A state indicating that the value is being refreshed (e.g., background update).
class RefreshingValue<T> extends Ephemeral<T> with EquatableMixin {
  @override
  final T? value;
  final String? message;

  const RefreshingValue([this.value, this.message]);

  @override
  String toString() => 'RefreshingValue(value: $value, message: $message)';

  @override
  List<Object?> get props => [value, message];
}

/// A state indicating that the value is available but outdated (stale).
class StaleValue<T> extends Ephemeral<T> with EquatableMixin {
  @override
  final T? value;
  final DateTime? lastUpdated;
  final String? message;

  const StaleValue([this.value, this.lastUpdated, this.message]);

  @override
  String toString() => 'StaleValue(value: $value, lastUpdated: $lastUpdated, message: $message)';

  @override
  List<Object?> get props => [value, lastUpdated, message];
}
