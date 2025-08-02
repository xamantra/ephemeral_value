import 'package:ephemeral_value/src/ephemeral_value_base.dart';
import 'package:test/test.dart';

class TestEphemeral<T> extends Ephemeral<T> {
  @override
  final T? value;
  const TestEphemeral(this.value);
}

void main() {
  group('Ephemeral Base Class', () {
    test('abstract class cannot be instantiated', () {
      expect(() => TestEphemeral<int>(42), returnsNormally);
      expect(TestEphemeral<int>(42), isA<Ephemeral<int>>());
    });

    test('value getter returns correct value', () {
      final test = TestEphemeral<int>(42);
      expect(test.value, 42);

      final testNull = TestEphemeral<int>(null);
      expect(testNull.value, null);
    });
  });

  group('NoneValue', () {
    test('constructor with null value', () {
      final none = NoneValue<int>(null);
      expect(none.value, null);
      expect(none.toString(), 'NoneValue(value: null)');
    });

    test('constructor with non-null value', () {
      final none = NoneValue<int>(42);
      expect(none.value, 42);
      expect(none.toString(), 'NoneValue(value: 42)');
    });

    test('equality with same values', () {
      final a = NoneValue<int>(null);
      final b = NoneValue<int>(null);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality with different values', () {
      final a = NoneValue<int>(null);
      final b = NoneValue<int>(42);
      expect(a, isNot(equals(b)));
    });

    test('props contains correct values', () {
      final none = NoneValue<String>('test');
      expect(none.props, ['test']);
    });

    test('props with null value', () {
      final none = NoneValue<String>(null);
      expect(none.props, [null]);
    });
  });

  group('InitialValue', () {
    test('constructor with value and message', () {
      final initial = InitialValue<int>(42, 'test message');
      expect(initial.value, 42);
      expect(initial.message, 'test message');
      expect(initial.toString(), 'InitialValue(value: 42, message: test message)');
    });

    test('constructor with value only', () {
      final initial = InitialValue<int>(42);
      expect(initial.value, 42);
      expect(initial.message, null);
      expect(initial.toString(), 'InitialValue(value: 42, message: null)');
    });

    test('equality with same values', () {
      final a = InitialValue<int>(42, 'message');
      final b = InitialValue<int>(42, 'message');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality with different values', () {
      final a = InitialValue<int>(42, 'message');
      final b = InitialValue<int>(43, 'message');
      final c = InitialValue<int>(42, 'different');
      expect(a, isNot(equals(b)));
      expect(a, isNot(equals(c)));
    });

    test('props contains correct values', () {
      final initial = InitialValue<String>('test', 'message');
      expect(initial.props, ['test', 'message']);
    });

    test('props with null message', () {
      final initial = InitialValue<String>('test');
      expect(initial.props, ['test', null]);
    });
  });

  group('LoadingValue', () {
    test('constructor with value and message', () {
      final loading = LoadingValue<int>(42, 'loading...');
      expect(loading.value, 42);
      expect(loading.message, 'loading...');
      expect(loading.toString(), 'LoadingValue(value: 42, message: loading...)');
    });

    test('constructor with value only', () {
      final loading = LoadingValue<int>(42);
      expect(loading.value, 42);
      expect(loading.message, null);
      expect(loading.toString(), 'LoadingValue(value: 42, message: null)');
    });

    test('constructor with no parameters', () {
      final loading = LoadingValue<int>();
      expect(loading.value, null);
      expect(loading.message, null);
      expect(loading.toString(), 'LoadingValue(value: null, message: null)');
    });

    test('equality with same values', () {
      final a = LoadingValue<int>(42, 'loading');
      final b = LoadingValue<int>(42, 'loading');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality with different values', () {
      final a = LoadingValue<int>(42, 'loading');
      final b = LoadingValue<int>(43, 'loading');
      final c = LoadingValue<int>(42, 'different');
      expect(a, isNot(equals(b)));
      expect(a, isNot(equals(c)));
    });

    test('props contains correct values', () {
      final loading = LoadingValue<String>('test', 'message');
      expect(loading.props, ['test', 'message']);
    });

    test('props with null values', () {
      final loading = LoadingValue<String>();
      expect(loading.props, [null, null]);
    });
  });

  group('SuccessValue', () {
    test('constructor with value and message', () {
      final success = SuccessValue<int>(42, 'success!');
      expect(success.value, 42);
      expect(success.message, 'success!');
      expect(success.toString(), 'SuccessValue(value: 42, message: success!)');
    });

    test('constructor with value only', () {
      final success = SuccessValue<int>(42);
      expect(success.value, 42);
      expect(success.message, null);
      expect(success.toString(), 'SuccessValue(value: 42, message: null)');
    });

    test('equality with same values', () {
      final a = SuccessValue<int>(42, 'success');
      final b = SuccessValue<int>(42, 'success');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality with different values', () {
      final a = SuccessValue<int>(42, 'success');
      final b = SuccessValue<int>(43, 'success');
      final c = SuccessValue<int>(42, 'different');
      expect(a, isNot(equals(b)));
      expect(a, isNot(equals(c)));
    });

    test('props contains correct values', () {
      final success = SuccessValue<String>('test', 'message');
      expect(success.props, ['test', 'message']);
    });

    test('props with null message', () {
      final success = SuccessValue<String>('test');
      expect(success.props, ['test', null]);
    });
  });

  group('ErrorValue', () {
    test('constructor with value and error', () {
      final error = ErrorValue<int>(42, 'error message');
      expect(error.value, 42);
      expect(error.error, 'error message');
      expect(error.toString(), 'ErrorValue(value: 42, error: error message)');
    });

    test('constructor with value only', () {
      final error = ErrorValue<int>(42);
      expect(error.value, 42);
      expect(error.error, null);
      expect(error.toString(), 'ErrorValue(value: 42, error: null)');
    });

    test('constructor with no parameters', () {
      final error = ErrorValue<int>();
      expect(error.value, null);
      expect(error.error, null);
      expect(error.toString(), 'ErrorValue(value: null, error: null)');
    });

    test('constructor with exception error', () {
      final exception = Exception('test exception');
      final error = ErrorValue<int>(42, exception);
      expect(error.value, 42);
      expect(error.error, exception);
      expect(error.toString(), contains('ErrorValue(value: 42, error: Exception: test exception'));
    });

    test('equality with same values', () {
      final a = ErrorValue<int>(42, 'error');
      final b = ErrorValue<int>(42, 'error');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality with different values', () {
      final a = ErrorValue<int>(42, 'error');
      final b = ErrorValue<int>(43, 'error');
      final c = ErrorValue<int>(42, 'different');
      expect(a, isNot(equals(b)));
      expect(a, isNot(equals(c)));
    });

    test('props contains correct values', () {
      final error = ErrorValue<String>('test', 'error');
      expect(error.props, ['test', 'error']);
    });

    test('props with null values', () {
      final error = ErrorValue<String>();
      expect(error.props, [null, null]);
    });
  });

  group('EmptyValue', () {
    test('constructor with value and message', () {
      final empty = EmptyValue<int>(42, 'empty message');
      expect(empty.value, 42);
      expect(empty.message, 'empty message');
      expect(empty.toString(), 'EmptyValue(value: 42, message: empty message)');
    });

    test('constructor with value only', () {
      final empty = EmptyValue<int>(42);
      expect(empty.value, 42);
      expect(empty.message, null);
      expect(empty.toString(), 'EmptyValue(value: 42, message: null)');
    });

    test('constructor with no parameters', () {
      final empty = EmptyValue<int>();
      expect(empty.value, null);
      expect(empty.message, null);
      expect(empty.toString(), 'EmptyValue(value: null, message: null)');
    });

    test('equality with same values', () {
      final a = EmptyValue<int>(42, 'empty');
      final b = EmptyValue<int>(42, 'empty');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality with different values', () {
      final a = EmptyValue<int>(42, 'empty');
      final b = EmptyValue<int>(43, 'empty');
      final c = EmptyValue<int>(42, 'different');
      expect(a, isNot(equals(b)));
      expect(a, isNot(equals(c)));
    });

    test('props contains correct values', () {
      final empty = EmptyValue<String>('test', 'message');
      expect(empty.props, ['test', 'message']);
    });

    test('props with null values', () {
      final empty = EmptyValue<String>();
      expect(empty.props, [null, null]);
    });
  });

  group('RefreshingValue', () {
    test('constructor with value and message', () {
      final refreshing = RefreshingValue<int>(42, 'refreshing...');
      expect(refreshing.value, 42);
      expect(refreshing.message, 'refreshing...');
      expect(refreshing.toString(), 'RefreshingValue(value: 42, message: refreshing...)');
    });

    test('constructor with value only', () {
      final refreshing = RefreshingValue<int>(42);
      expect(refreshing.value, 42);
      expect(refreshing.message, null);
      expect(refreshing.toString(), 'RefreshingValue(value: 42, message: null)');
    });

    test('constructor with no parameters', () {
      final refreshing = RefreshingValue<int>();
      expect(refreshing.value, null);
      expect(refreshing.message, null);
      expect(refreshing.toString(), 'RefreshingValue(value: null, message: null)');
    });

    test('equality with same values', () {
      final a = RefreshingValue<int>(42, 'refreshing');
      final b = RefreshingValue<int>(42, 'refreshing');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality with different values', () {
      final a = RefreshingValue<int>(42, 'refreshing');
      final b = RefreshingValue<int>(43, 'refreshing');
      final c = RefreshingValue<int>(42, 'different');
      expect(a, isNot(equals(b)));
      expect(a, isNot(equals(c)));
    });

    test('props contains correct values', () {
      final refreshing = RefreshingValue<String>('test', 'message');
      expect(refreshing.props, ['test', 'message']);
    });

    test('props with null values', () {
      final refreshing = RefreshingValue<String>();
      expect(refreshing.props, [null, null]);
    });
  });

  group('StaleValue', () {
    test('constructor with all parameters', () {
      final now = DateTime.now();
      final stale = StaleValue<int>(42, now, 'stale message');
      expect(stale.value, 42);
      expect(stale.lastUpdated, now);
      expect(stale.message, 'stale message');
      expect(stale.toString(), 'StaleValue(value: 42, lastUpdated: $now, message: stale message)');
    });

    test('constructor with value and lastUpdated', () {
      final now = DateTime.now();
      final stale = StaleValue<int>(42, now);
      expect(stale.value, 42);
      expect(stale.lastUpdated, now);
      expect(stale.message, null);
      expect(stale.toString(), 'StaleValue(value: 42, lastUpdated: $now, message: null)');
    });

    test('constructor with value only', () {
      final stale = StaleValue<int>(42);
      expect(stale.value, 42);
      expect(stale.lastUpdated, null);
      expect(stale.message, null);
      expect(stale.toString(), 'StaleValue(value: 42, lastUpdated: null, message: null)');
    });

    test('constructor with no parameters', () {
      final stale = StaleValue<int>();
      expect(stale.value, null);
      expect(stale.lastUpdated, null);
      expect(stale.message, null);
      expect(stale.toString(), 'StaleValue(value: null, lastUpdated: null, message: null)');
    });

    test('equality with same values', () {
      final now = DateTime.now();
      final a = StaleValue<int>(42, now, 'stale');
      final b = StaleValue<int>(42, now, 'stale');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality with different values', () {
      final now = DateTime.now();
      final a = StaleValue<int>(42, now, 'stale');
      final b = StaleValue<int>(43, now, 'stale');
      final c = StaleValue<int>(42, now, 'different');
      expect(a, isNot(equals(b)));
      expect(a, isNot(equals(c)));
    });

    test('props contains correct values', () {
      final now = DateTime.now();
      final stale = StaleValue<String>('test', now, 'message');
      expect(stale.props, ['test', now, 'message']);
    });

    test('props with null values', () {
      final stale = StaleValue<String>();
      expect(stale.props, [null, null, null]);
    });
  });

  group('State Transitions', () {
    late TestEphemeral<int> testEphemeral;

    setUp(() {
      testEphemeral = TestEphemeral<int>(42);
    });

    group('toNone', () {
      test('retains current value when no parameter provided', () {
        final result = testEphemeral.toNone();
        expect(result, isA<NoneValue<int>>());
        expect(result.value, 42);
      });

      test('uses provided value when parameter provided', () {
        final result = testEphemeral.toNone(100);
        expect(result, isA<NoneValue<int>>());
        expect(result.value, 100);
      });

      test('works with null value', () {
        final nullEphemeral = TestEphemeral<int>(null);
        final result = nullEphemeral.toNone();
        expect(result, isA<NoneValue<int>>());
        expect(result.value, null);
      });
    });

    group('toInitial', () {
      test('retains current value when no parameter provided', () {
        final result = testEphemeral.toInitial();
        expect(result, isA<InitialValue<int>>());
        expect(result.value, 42);
        expect(result.message, null);
      });

      test('uses provided value and message when parameters provided', () {
        final result = testEphemeral.toInitial(100, 'new initial');
        expect(result, isA<InitialValue<int>>());
        expect(result.value, 100);
        expect(result.message, 'new initial');
      });

      test('throws assertion error when current value is null and no new value provided', () {
        final nullEphemeral = TestEphemeral<int>(null);
        expect(() => nullEphemeral.toInitial(), throwsA(isA<AssertionError>()));
      });

      test('works when current value is null but new value is provided', () {
        final nullEphemeral = TestEphemeral<int>(null);
        final result = nullEphemeral.toInitial(100, 'initial');
        expect(result, isA<InitialValue<int>>());
        expect(result.value, 100);
        expect(result.message, 'initial');
      });
    });

    group('toLoading', () {
      test('retains current value when no parameter provided', () {
        final result = testEphemeral.toLoading();
        expect(result, isA<LoadingValue<int>>());
        expect(result.value, 42);
        expect(result.message, null);
      });

      test('uses provided value and message when parameters provided', () {
        final result = testEphemeral.toLoading(100, 'loading...');
        expect(result, isA<LoadingValue<int>>());
        expect(result.value, 100);
        expect(result.message, 'loading...');
      });

      test('works with null value', () {
        final nullEphemeral = TestEphemeral<int>(null);
        final result = nullEphemeral.toLoading();
        expect(result, isA<LoadingValue<int>>());
        expect(result.value, null);
      });
    });

    group('toSuccess', () {
      test('retains current value when no parameter provided', () {
        final result = testEphemeral.toSuccess();
        expect(result, isA<SuccessValue<int>>());
        expect(result.value, 42);
        expect(result.message, null);
      });

      test('uses provided value and message when parameters provided', () {
        final result = testEphemeral.toSuccess(100, 'success!');
        expect(result, isA<SuccessValue<int>>());
        expect(result.value, 100);
        expect(result.message, 'success!');
      });

      test('throws assertion error when current value is null and no new value provided', () {
        final nullEphemeral = TestEphemeral<int>(null);
        expect(() => nullEphemeral.toSuccess(), throwsA(isA<AssertionError>()));
      });

      test('works when current value is null but new value is provided', () {
        final nullEphemeral = TestEphemeral<int>(null);
        final result = nullEphemeral.toSuccess(100, 'success');
        expect(result, isA<SuccessValue<int>>());
        expect(result.value, 100);
        expect(result.message, 'success');
      });
    });

    group('toError', () {
      test('retains current value when no parameter provided', () {
        final result = testEphemeral.toError();
        expect(result, isA<ErrorValue<int>>());
        expect(result.value, 42);
        expect(result.error, null);
      });

      test('uses provided value and error when parameters provided', () {
        final error = Exception('test error');
        final result = testEphemeral.toError(100, error);
        expect(result, isA<ErrorValue<int>>());
        expect(result.value, 100);
        expect(result.error, error);
      });

      test('works with null value', () {
        final nullEphemeral = TestEphemeral<int>(null);
        final result = nullEphemeral.toError();
        expect(result, isA<ErrorValue<int>>());
        expect(result.value, null);
      });
    });

    group('toEmpty', () {
      test('retains current value when no parameter provided', () {
        final result = testEphemeral.toEmpty();
        expect(result, isA<EmptyValue<int>>());
        expect(result.value, 42);
        expect(result.message, null);
      });

      test('uses provided value and message when parameters provided', () {
        final result = testEphemeral.toEmpty(100, 'empty');
        expect(result, isA<EmptyValue<int>>());
        expect(result.value, 100);
        expect(result.message, 'empty');
      });

      test('works with null value', () {
        final nullEphemeral = TestEphemeral<int>(null);
        final result = nullEphemeral.toEmpty();
        expect(result, isA<EmptyValue<int>>());
        expect(result.value, null);
      });
    });

    group('toRefreshing', () {
      test('retains current value when no parameter provided', () {
        final result = testEphemeral.toRefreshing();
        expect(result, isA<RefreshingValue<int>>());
        expect(result.value, 42);
        expect(result.message, null);
      });

      test('uses provided value and message when parameters provided', () {
        final result = testEphemeral.toRefreshing(100, 'refreshing...');
        expect(result, isA<RefreshingValue<int>>());
        expect(result.value, 100);
        expect(result.message, 'refreshing...');
      });

      test('works with null value', () {
        final nullEphemeral = TestEphemeral<int>(null);
        final result = nullEphemeral.toRefreshing();
        expect(result, isA<RefreshingValue<int>>());
        expect(result.value, null);
      });
    });

    group('toStale', () {
      test('retains current value when no parameter provided', () {
        final result = testEphemeral.toStale();
        expect(result, isA<StaleValue<int>>());
        expect(result.value, 42);
        expect(result.lastUpdated, null);
        expect(result.message, null);
      });

      test('uses provided value, lastUpdated, and message when parameters provided', () {
        final now = DateTime.now();
        final result = testEphemeral.toStale(100, now, 'stale');
        expect(result, isA<StaleValue<int>>());
        expect(result.value, 100);
        expect(result.lastUpdated, now);
        expect(result.message, 'stale');
      });

      test('works with null value', () {
        final nullEphemeral = TestEphemeral<int>(null);
        final result = nullEphemeral.toStale();
        expect(result, isA<StaleValue<int>>());
        expect(result.value, null);
      });
    });
  });

  group('Type Safety', () {
    test('all ephemeral types are instances of Ephemeral', () {
      expect(NoneValue<int>(null), isA<Ephemeral<int>>());
      expect(InitialValue<int>(42), isA<Ephemeral<int>>());
      expect(LoadingValue<int>(42), isA<Ephemeral<int>>());
      expect(SuccessValue<int>(42), isA<Ephemeral<int>>());
      expect(ErrorValue<int>(42), isA<Ephemeral<int>>());
      expect(EmptyValue<int>(42), isA<Ephemeral<int>>());
      expect(RefreshingValue<int>(42), isA<Ephemeral<int>>());
      expect(StaleValue<int>(42), isA<Ephemeral<int>>());
    });

    test('generic type parameters work correctly', () {
      final stringNone = NoneValue<String>('test');
      final intNone = NoneValue<int>(42);

      expect(stringNone.value, isA<String>());
      expect(intNone.value, isA<int>());
    });
  });

  group('Edge Cases', () {
    test('complex objects in ephemeral values', () {
      final complexObject = {'key': 'value', 'number': 42};
      final none = NoneValue<Map<String, dynamic>>(complexObject);
      final success = SuccessValue<Map<String, dynamic>>(complexObject);

      expect(none.value, complexObject);
      expect(success.value, complexObject);
    });

    test('null values in all ephemeral types', () {
      expect(NoneValue<int>(null).value, null);
      expect(LoadingValue<int>(null).value, null);
      expect(ErrorValue<int>(null).value, null);
      expect(EmptyValue<int>(null).value, null);
      expect(RefreshingValue<int>(null).value, null);
      expect(StaleValue<int>(null).value, null);
    });

    test('empty strings and collections', () {
      expect(EmptyValue<String>('').value, '');
      expect(EmptyValue<List<int>>([]).value, isEmpty);
      expect(EmptyValue<Map<String, int>>({}).value, isEmpty);
    });
  });

  group('Integration Tests', () {
    test('complete state transition cycle', () {
      // Start with None
      Ephemeral<int> state = NoneValue<int>(null);
      expect(state, isA<NoneValue<int>>());
      expect(state.value, null);

      // Transition to Initial
      state = state.toInitial(42, 'initialized');
      expect(state, isA<InitialValue<int>>());
      expect(state.value, 42);
      expect((state as InitialValue<int>).message, 'initialized');

      // Transition to Loading
      state = state.toLoading(42, 'loading...');
      expect(state, isA<LoadingValue<int>>());
      expect(state.value, 42);
      expect((state as LoadingValue<int>).message, 'loading...');

      // Transition to Success
      state = state.toSuccess(100, 'success!');
      expect(state, isA<SuccessValue<int>>());
      expect(state.value, 100);
      expect((state as SuccessValue<int>).message, 'success!');

      // Transition to Refreshing
      state = state.toRefreshing(100, 'refreshing...');
      expect(state, isA<RefreshingValue<int>>());
      expect(state.value, 100);
      expect((state as RefreshingValue<int>).message, 'refreshing...');

      // Transition to Stale
      final now = DateTime.now();
      state = state.toStale(100, now, 'stale');
      expect(state, isA<StaleValue<int>>());
      expect(state.value, 100);
      expect((state as StaleValue<int>).lastUpdated, now);
      expect((state).message, 'stale');

      // Transition to Error
      state = state.toError(100, 'error occurred');
      expect(state, isA<ErrorValue<int>>());
      expect(state.value, 100);
      expect((state as ErrorValue<int>).error, 'error occurred');

      // Transition to Empty
      state = state.toEmpty(0, 'empty');
      expect(state, isA<EmptyValue<int>>());
      expect(state.value, 0);
      expect((state as EmptyValue<int>).message, 'empty');

      // Back to None
      state = state.toNone();
      expect(state, isA<NoneValue<int>>());
      expect(state.value, 0);
    });

    test('state transitions preserve value when no new value provided', () {
      Ephemeral<int> state = InitialValue<int>(42, 'initial');

      state = state.toLoading();
      expect(state.value, 42);

      state = state.toSuccess();
      expect(state.value, 42);

      state = state.toRefreshing();
      expect(state.value, 42);

      state = state.toStale();
      expect(state.value, 42);

      state = state.toError();
      expect(state.value, 42);

      state = state.toEmpty();
      expect(state.value, 42);

      state = state.toNone();
      expect(state.value, 42);
    });
  });
}
