import 'index.dart';

extension EphemeralExt<T> on Ephemeral<T> {
  bool get isNone => this is NoneValue<T>;
  T? get getNone {
    if (this is NoneValue<T>) {
      return (this as NoneValue<T>).value;
    }
    throw StateError('Not a NoneValue<$T>. Make sure to check isNone before calling getNone.');
  }

  bool get isInitial => this is InitialValue<T>;
  T get getInitial {
    if (this is InitialValue<T>) {
      return (this as InitialValue<T>).value;
    }
    throw StateError('Not an InitialValue<$T>. Make sure to check isInitial before calling getInitial.');
  }

  bool get isLoading => this is LoadingValue<T>;
  T? get getLoading {
    if (this is LoadingValue<T>) {
      return (this as LoadingValue<T>).value;
    }
    throw StateError('Not a LoadingValue<$T>. Make sure to check isLoading before calling getLoading.');
  }

  bool get isSuccess => this is SuccessValue<T>;
  T get getSuccess {
    if (this is SuccessValue<T>) {
      return (this as SuccessValue<T>).value;
    }
    throw StateError('Not a SuccessValue<$T>. Make sure to check isSuccess before calling getSuccess.');
  }

  bool get isError => this is ErrorValue<T>;
  Object? get getError {
    if (this is ErrorValue<T>) {
      return (this as ErrorValue<T>).error;
    }
    throw StateError('Not an ErrorValue<$T>. Make sure to check isError before calling getError.');
  }

  bool get isEmpty => this is EmptyValue<T>;
  T? get getEmpty {
    if (this is EmptyValue<T>) {
      return (this as EmptyValue<T>).value;
    }
    throw StateError('Not an EmptyValue<$T>. Make sure to check isEmpty before calling getEmpty.');
  }

  bool get isRefreshing => this is RefreshingValue<T>;
  T? get getRefreshing {
    if (this is RefreshingValue<T>) {
      return (this as RefreshingValue<T>).value;
    }
    throw StateError('Not a RefreshingValue<$T>. Make sure to check isRefreshing before calling getRefreshing.');
  }

  bool get isStale => this is StaleValue<T>;
  T? get getStale {
    if (this is StaleValue<T>) {
      return (this as StaleValue<T>).value;
    }
    throw StateError('Not a StaleValue<$T>. Make sure to check isStale before calling getStale.');
  }
  
  DateTime? get getStaleLastUpdated {
    if (this is StaleValue<T>) {
      return (this as StaleValue<T>).lastUpdated;
    }
    throw StateError('Not a StaleValue<$T>. Make sure to check isStale before calling getStaleLastUpdated.');
  }

  // Message getters for states that support messages
  String? get getInitialMessage {
    if (this is InitialValue<T>) {
      return (this as InitialValue<T>).message;
    }
    throw StateError('Not an InitialValue<$T>. Make sure to check isInitial before calling getInitialMessage.');
  }

  String? get getLoadingMessage {
    if (this is LoadingValue<T>) {
      return (this as LoadingValue<T>).message;
    }
    throw StateError('Not a LoadingValue<$T>. Make sure to check isLoading before calling getLoadingMessage.');
  }

  String? get getSuccessMessage {
    if (this is SuccessValue<T>) {
      return (this as SuccessValue<T>).message;
    }
    throw StateError('Not a SuccessValue<$T>. Make sure to check isSuccess before calling getSuccessMessage.');
  }

  String? get getEmptyMessage {
    if (this is EmptyValue<T>) {
      return (this as EmptyValue<T>).message;
    }
    throw StateError('Not an EmptyValue<$T>. Make sure to check isEmpty before calling getEmptyMessage.');
  }

  String? get getRefreshingMessage {
    if (this is RefreshingValue<T>) {
      return (this as RefreshingValue<T>).message;
    }
    throw StateError('Not a RefreshingValue<$T>. Make sure to check isRefreshing before calling getRefreshingMessage.');
  }

  String? get getStaleMessage {
    if (this is StaleValue<T>) {
      return (this as StaleValue<T>).message;
    }
    throw StateError('Not a StaleValue<$T>. Make sure to check isStale before calling getStaleMessage.');
  }
}
