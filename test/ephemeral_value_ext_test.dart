import 'package:ephemeral_value/ephemeral_value.dart';
import 'package:test/test.dart';

void main() {
  group('EphemeralValue Extensions', () {
    group('isNone and getNone', () {
      test('isNone returns true for NoneValue', () {
        final none = NoneValue<int>(null);
        expect(none.isNone, isTrue);
      });

      test('isNone returns false for other types', () {
        final success = SuccessValue<int>(42);
        expect(success.isNone, isFalse);
      });

      test('getNone returns value for NoneValue', () {
        final none = NoneValue<int>(42);
        expect(none.getNone, 42);
      });

      test('getNone throws StateError for non-NoneValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getNone, throwsStateError);
      });
    });

    group('isInitial and getInitial', () {
      test('isInitial returns true for InitialValue', () {
        final initial = InitialValue<int>(42);
        expect(initial.isInitial, isTrue);
      });

      test('isInitial returns false for other types', () {
        final success = SuccessValue<int>(42);
        expect(success.isInitial, isFalse);
      });

      test('getInitial returns value for InitialValue', () {
        final initial = InitialValue<int>(42);
        expect(initial.getInitial, 42);
      });

      test('getInitial throws StateError for non-InitialValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getInitial, throwsStateError);
      });
    });

    group('isLoading and getLoading', () {
      test('isLoading returns true for LoadingValue', () {
        final loading = LoadingValue<int>(42);
        expect(loading.isLoading, isTrue);
      });

      test('isLoading returns false for other types', () {
        final success = SuccessValue<int>(42);
        expect(success.isLoading, isFalse);
      });

      test('getLoading returns value for LoadingValue', () {
        final loading = LoadingValue<int>(42);
        expect(loading.getLoading, 42);
      });

      test('getLoading throws StateError for non-LoadingValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getLoading, throwsStateError);
      });
    });

    group('isSuccess and getSuccess', () {
      test('isSuccess returns true for SuccessValue', () {
        final success = SuccessValue<int>(42);
        expect(success.isSuccess, isTrue);
      });

      test('isSuccess returns false for other types', () {
        final loading = LoadingValue<int>(42);
        expect(loading.isSuccess, isFalse);
      });

      test('getSuccess returns value for SuccessValue', () {
        final success = SuccessValue<int>(42);
        expect(success.getSuccess, 42);
      });

      test('getSuccess throws StateError for non-SuccessValue', () {
        final loading = LoadingValue<int>(42);
        expect(() => loading.getSuccess, throwsStateError);
      });
    });

    group('isError and getError', () {
      test('isError returns true for ErrorValue', () {
        final error = ErrorValue<int>(42);
        expect(error.isError, isTrue);
      });

      test('isError returns false for other types', () {
        final success = SuccessValue<int>(42);
        expect(success.isError, isFalse);
      });

      test('getError returns error for ErrorValue', () {
        final error = ErrorValue<int>(42, 'test error');
        expect(error.getError, 'test error');
      });

      test('getError throws StateError for non-ErrorValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getError, throwsStateError);
      });
    });

    group('isEmpty and getEmpty', () {
      test('isEmpty returns true for EmptyValue', () {
        final empty = EmptyValue<int>(42);
        expect(empty.isEmpty, isTrue);
      });

      test('isEmpty returns false for other types', () {
        final success = SuccessValue<int>(42);
        expect(success.isEmpty, isFalse);
      });

      test('getEmpty returns value for EmptyValue', () {
        final empty = EmptyValue<int>(42);
        expect(empty.getEmpty, 42);
      });

      test('getEmpty throws StateError for non-EmptyValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getEmpty, throwsStateError);
      });
    });

    group('isRefreshing and getRefreshing', () {
      test('isRefreshing returns true for RefreshingValue', () {
        final refreshing = RefreshingValue<int>(42);
        expect(refreshing.isRefreshing, isTrue);
      });

      test('isRefreshing returns false for other types', () {
        final success = SuccessValue<int>(42);
        expect(success.isRefreshing, isFalse);
      });

      test('getRefreshing returns value for RefreshingValue', () {
        final refreshing = RefreshingValue<int>(42);
        expect(refreshing.getRefreshing, 42);
      });

      test('getRefreshing throws StateError for non-RefreshingValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getRefreshing, throwsStateError);
      });
    });

    group('isStale, getStale, and getStaleLastUpdated', () {
      test('isStale returns true for StaleValue', () {
        final stale = StaleValue<int>(42);
        expect(stale.isStale, isTrue);
      });

      test('isStale returns false for other types', () {
        final success = SuccessValue<int>(42);
        expect(success.isStale, isFalse);
      });

      test('getStale returns value for StaleValue', () {
        final stale = StaleValue<int>(42);
        expect(stale.getStale, 42);
      });

      test('getStale throws StateError for non-StaleValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getStale, throwsStateError);
      });

      test('getStaleLastUpdated returns lastUpdated for StaleValue', () {
        final now = DateTime.now();
        final stale = StaleValue<int>(42, now);
        expect(stale.getStaleLastUpdated, now);
      });

      test('getStaleLastUpdated throws StateError for non-StaleValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getStaleLastUpdated, throwsStateError);
      });
    });

    group('Message getters', () {
      test('getInitialMessage returns message for InitialValue', () {
        final initial = InitialValue<int>(42, 'initial message');
        expect(initial.getInitialMessage, 'initial message');
      });

      test('getInitialMessage throws StateError for non-InitialValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getInitialMessage, throwsStateError);
      });

      test('getLoadingMessage returns message for LoadingValue', () {
        final loading = LoadingValue<int>(42, 'loading message');
        expect(loading.getLoadingMessage, 'loading message');
      });

      test('getLoadingMessage throws StateError for non-LoadingValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getLoadingMessage, throwsStateError);
      });

      test('getSuccessMessage returns message for SuccessValue', () {
        final success = SuccessValue<int>(42, 'success message');
        expect(success.getSuccessMessage, 'success message');
      });

      test('getSuccessMessage throws StateError for non-SuccessValue', () {
        final loading = LoadingValue<int>(42);
        expect(() => loading.getSuccessMessage, throwsStateError);
      });

      test('getEmptyMessage returns message for EmptyValue', () {
        final empty = EmptyValue<int>(42, 'empty message');
        expect(empty.getEmptyMessage, 'empty message');
      });

      test('getEmptyMessage throws StateError for non-EmptyValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getEmptyMessage, throwsStateError);
      });

      test('getRefreshingMessage returns message for RefreshingValue', () {
        final refreshing = RefreshingValue<int>(42, 'refreshing message');
        expect(refreshing.getRefreshingMessage, 'refreshing message');
      });

      test('getRefreshingMessage throws StateError for non-RefreshingValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getRefreshingMessage, throwsStateError);
      });

      test('getStaleMessage returns message for StaleValue', () {
        final stale = StaleValue<int>(42, null, 'stale message');
        expect(stale.getStaleMessage, 'stale message');
      });

      test('getStaleMessage throws StateError for non-StaleValue', () {
        final success = SuccessValue<int>(42);
        expect(() => success.getStaleMessage, throwsStateError);
      });
    });

    group('Null value handling', () {
      test('getNone handles null values', () {
        final none = NoneValue<int>(null);
        expect(none.getNone, null);
      });

      test('getLoading handles null values', () {
        final loading = LoadingValue<int>(null);
        expect(loading.getLoading, null);
      });

      test('getError handles null values', () {
        final error = ErrorValue<int>(null);
        expect(error.getError, null);
      });

      test('getEmpty handles null values', () {
        final empty = EmptyValue<int>(null);
        expect(empty.getEmpty, null);
      });

      test('getRefreshing handles null values', () {
        final refreshing = RefreshingValue<int>(null);
        expect(refreshing.getRefreshing, null);
      });

      test('getStale handles null values', () {
        final stale = StaleValue<int>(null);
        expect(stale.getStale, null);
      });
    });

    group('Null message handling', () {
      test('getInitialMessage handles null messages', () {
        final initial = InitialValue<int>(42);
        expect(initial.getInitialMessage, null);
      });

      test('getLoadingMessage handles null messages', () {
        final loading = LoadingValue<int>(42);
        expect(loading.getLoadingMessage, null);
      });

      test('getSuccessMessage handles null messages', () {
        final success = SuccessValue<int>(42);
        expect(success.getSuccessMessage, null);
      });

      test('getEmptyMessage handles null messages', () {
        final empty = EmptyValue<int>(42);
        expect(empty.getEmptyMessage, null);
      });

      test('getRefreshingMessage handles null messages', () {
        final refreshing = RefreshingValue<int>(42);
        expect(refreshing.getRefreshingMessage, null);
      });

      test('getStaleMessage handles null messages', () {
        final stale = StaleValue<int>(42);
        expect(stale.getStaleMessage, null);
      });
    });

    group('Complex type handling', () {
      test('extensions work with complex types', () {
        final complexData = {'key': 'value', 'number': 42};

        final none = NoneValue<Map<String, dynamic>>(complexData);
        expect(none.getNone, complexData);

        final success = SuccessValue<Map<String, dynamic>>(complexData);
        expect(success.getSuccess, complexData);
      });

      test('extensions work with lists', () {
        final list = [1, 2, 3, 4, 5];

        final loading = LoadingValue<List<int>>(list);
        expect(loading.getLoading, list);

        final empty = EmptyValue<List<int>>(list);
        expect(empty.getEmpty, list);
      });
    });

    group('Error message content', () {
      test('StateError messages are descriptive', () {
        final success = SuccessValue<int>(42);

        expect(
          () => success.getNone,
          throwsA(
            predicate((e) => e.toString().contains('Not a NoneValue')),
          ),
        );

        expect(
          () => success.getInitial,
          throwsA(
            predicate((e) => e.toString().contains('Not an InitialValue')),
          ),
        );

        expect(
          () => success.getLoading,
          throwsA(
            predicate((e) => e.toString().contains('Not a LoadingValue')),
          ),
        );

        expect(
          () => success.getError,
          throwsA(
            predicate((e) => e.toString().contains('Not an ErrorValue')),
          ),
        );

        expect(
          () => success.getEmpty,
          throwsA(
            predicate((e) => e.toString().contains('Not an EmptyValue')),
          ),
        );

        expect(
          () => success.getRefreshing,
          throwsA(
            predicate((e) => e.toString().contains('Not a RefreshingValue')),
          ),
        );

        expect(
          () => success.getStale,
          throwsA(
            predicate((e) => e.toString().contains('Not a StaleValue')),
          ),
        );
      });
    });
  });
}
