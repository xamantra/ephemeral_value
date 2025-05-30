import 'package:ephemeral_value/src/ephemeral_value_base.dart';
import 'package:test/test.dart';

class TestEphemeral<T> extends Ephemeral<T> {
  @override
  final T? value;
  const TestEphemeral(this.value);
}

void main() {
  group('EphemeralValueBase', () {
    test('NoneValue equality, toString, and props', () {
      final a = NoneValue<int>(null);
      final b = NoneValue<int>(null);
      final c = NoneValue<int>(1);

      expect(a, equals(b));
      expect(a == c, isFalse);
      expect(a.toString(), 'NoneValue(value: null)');
      expect(c.toString(), 'NoneValue(value: 1)');
      expect(a.props, [null]);
      expect(c.props, [1]);
    });

    test('InitialValue equality, toString, and props', () {
      final a = InitialValue<int>(0, 'msg');
      final b = InitialValue<int>(0, 'msg');
      final c = InitialValue<int>(1);

      expect(a, equals(b));
      expect(a == c, isFalse);
      expect(a.toString(), 'InitialValue(value: 0, message: msg)');
      expect(c.toString(), 'InitialValue(value: 1, message: null)');
      expect(a.props, [0, 'msg']);
      expect(c.props, [1, null]);
    });

    test('LoadingValue equality, toString, and props', () {
      final a = LoadingValue<int>(2, 'loading');
      final b = LoadingValue<int>(2, 'loading');
      final c = LoadingValue<int>(null);

      expect(a, equals(b));
      expect(a == c, isFalse);
      expect(a.toString(), 'LoadingValue(value: 2, message: loading)');
      expect(c.toString(), 'LoadingValue(value: null, message: null)');
      expect(a.props, [2, 'loading']);
      expect(c.props, [null, null]);
    });

    test('SuccessValue equality, toString, and props', () {
      final a = SuccessValue<int>(3, 'done');
      final b = SuccessValue<int>(3, 'done');
      final c = SuccessValue<int>(4);

      expect(a, equals(b));
      expect(a == c, isFalse);
      expect(a.toString(), 'SuccessValue(value: 3, message: done)');
      expect(c.toString(), 'SuccessValue(value: 4, message: null)');
      expect(a.props, [3, 'done']);
      expect(c.props, [4, null]);
    });

    test('ErrorValue equality, toString, and props', () {
      final a = ErrorValue<int>(null, 'err');
      final b = ErrorValue<int>(null, 'err');
      final c = ErrorValue<int>(1, Exception('fail'));

      expect(a, equals(b));
      expect(a == c, isFalse);
      expect(a.toString(), 'ErrorValue(value: null, error: err)');
      expect(c.toString(), startsWith('ErrorValue(value: 1, error: Exception: fail'));
      expect(a.props, [null, 'err']);
      expect(c.props[0], 1);
      expect(c.props[1], isA<Exception>());
    });

    test('EmptyValue equality, toString, and props', () {
      final a = EmptyValue<List<int>>([], 'empty');
      final b = EmptyValue<List<int>>([], 'empty');
      final c = EmptyValue<List<int>>(null);

      expect(a, equals(b));
      expect(a == c, isFalse);
      expect(a.toString(), 'EmptyValue(value: [], message: empty)');
      expect(c.toString(), 'EmptyValue(value: null, message: null)');
      expect(a.props, [[], 'empty']);
      expect(c.props, [null, null]);
    });

    test('Ephemeral state transitions', () {
      final none = NoneValue<int>(null);
      final initial = InitialValue<int>(1, 'init');
      final loading = LoadingValue<int>(2, 'loading');
      final success = SuccessValue<int>(3, 'success');
      final error = ErrorValue<int>(4, 'error');
      // final empty = EmptyValue<int>(5, 'empty');

      // toNone
      expect(initial.toNone().runtimeType, NoneValue<int>);
      expect(initial.toNone(10).value, 10);

      // toInitial
      expect(none.toInitial(1, 'msg').runtimeType, InitialValue<int>);
      expect(() => none.toInitial(), throwsA(isA<AssertionError>()));
      expect(initial.toInitial(2, 'new').value, 2);

      // toLoading
      expect(success.toLoading().runtimeType, LoadingValue<int>);
      expect(success.toLoading(99, 'load').value, 99);

      // toSuccess
      expect(loading.toSuccess(7, 'ok').runtimeType, SuccessValue<int>);
      expect(() => none.toSuccess(), throwsA(isA<AssertionError>()));

      // toError
      expect(success.toError(8, 'err').runtimeType, ErrorValue<int>);
      expect(error.toError().runtimeType, ErrorValue<int>);

      // toEmpty
      expect(success.toEmpty().runtimeType, EmptyValue<int>);
      expect(success.toEmpty(0, 'empty').value, 0);
    });

    test('All Ephemeral types are Ephemeral', () {
      final none = NoneValue<String>(null);
      final initial = InitialValue<String>('init');
      final loading = LoadingValue<String>('load');
      final success = SuccessValue<String>('ok');
      final error = ErrorValue<String>('fail');
      final empty = EmptyValue<String>('');

      expect(none, isA<Ephemeral<String>>());
      expect(initial, isA<Ephemeral<String>>());
      expect(loading, isA<Ephemeral<String>>());
      expect(success, isA<Ephemeral<String>>());
      expect(error, isA<Ephemeral<String>>());
      expect(empty, isA<Ephemeral<String>>());
    });

    test('TestEphemeral for abstract class coverage', () {
      Ephemeral<int> t;
      t = TestEphemeral<int>(42);
      expect(t, isA<TestEphemeral<int>>());
      expect(t.value, 42);
      expect(t.toNone().value, 42);
      expect(t.toInitial(1, 'msg').value, 1);
      expect(t.toLoading().value, 42);
      expect(t.toSuccess(2, 'ok').value, 2);
      expect(() => TestEphemeral<int>(null).toSuccess(), throwsA(isA<AssertionError>()));
      expect(t.toError().value, 42);
      expect(t.toEmpty().value, 42);

      // Test toInitial with null value
      final n = TestEphemeral<int>(null);
      expect(() => n.toInitial(), throwsA(isA<AssertionError>()));
    });
  });
}
