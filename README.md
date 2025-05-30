# 🌟 Ephemeral Value

[![pub package](https://img.shields.io/pub/v/ephemeral_value.svg)](https://pub.dev/packages/ephemeral_value)
[![codecov](https://codecov.io/gh/xamantra/ephemeral_value/branch/dev/graph/badge.svg?token=UDJ7RRLSZI)](https://codecov.io/gh/xamantra/ephemeral_value)
![GitHub License](https://img.shields.io/github/license/xamantra/ephemeral_value?label=license)


<!-- [![GitHub stars](https://img.shields.io/github/stars/xamantra/ephemeral_value.svg?style=social)](https://github.com/xamantra/ephemeral_value) -->

**Ephemeral Value** is a Dart library for representing and managing the
transient (ephemeral) state of any value. Effortlessly model loading, success,
error, empty, and initial states in your Dart and Flutter apps with a simple,
type-safe API.

---

## ✨ Features

- **Unified State Representation:** Model loading, success, error, empty, and
  initial states with dedicated classes.
- **Type Safety:** All states are generic and strongly typed.
- **Easy State Transitions:** Built-in methods for transitioning between states.
- **Equatable Support:** All states are value-equal for easy comparison.
- **Flutter & Dart Ready:** Works seamlessly in both Dart and Flutter projects.

---

## 🚀 Getting Started

### 1. Install

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ephemeral_value: ^1.0.0
```

### 2. Import

```dart
import 'package:ephemeral_value/ephemeral_value.dart';
```

---

## 🧩 Usage

Ephemeral value types:

- `NoneValue()` or `NoneValue("Jane Doe")`: Initial nullable value (optional).
- `InitialValue(guestUser)`: Initial non-null value.
- `LoadingValue()`: Loading state (optional value).
- `SuccessValue(userObj)`: Loaded successfully (non-null value).
- `ErrorValue(null, errorObj)`: Error state (optional value, error object).
- `EmptyValue()`: Loaded but empty or null.

### Example: State Class

```dart
class LoginState {
  final Ephemeral<User> user;

  LoginState({this.user = const NoneValue(null)});

  LoginState copyWith({Ephemeral<User>? user}) {
    return LoginState(user: user ?? this.user);
  }
}
```

### Example: Bloc Logic

```dart
try {
  emit(state.copyWith(user: LoadingValue(null)));
  final user = await UserRepository().getUser(event.id);
  emit(state.copyWith(user: SuccessValue(user)));
} catch (e) {
  emit(state.copyWith(user: ErrorValue(null, e)));
  // Or use transition methods:
  emit(state.copyWith(user: state.user.toError()));
}
```

### Example: Widget UI

```dart
if (state.user is LoadingValue) {
  return const CircularProgressIndicator();
} else if (state.user is SuccessValue) {
  return Text('User: ${state.user.value.name}');
} else if (state.user is ErrorValue) {
  return Text('Error: ${state.user.error}');
}
```

---

## 🛠️ Transition Helpers

Sometimes, when you want to refresh a state (like user object) you might get an
error. In this case, you still want to display the current user data and at the
same time show the error message. You can use `toError()` method to achieve
this. It retains the current value if you pass `null` as the value.

```dart
Ephemeral<T> user = NoneValue(null);

user = user.toLoading(); // LoadingValue
user = user.toSuccess(newValue); // SuccessValue
user = user.toError(null, error); // ErrorValue
user = user.toEmpty(); // EmptyValue
```

If you want to force a new value (like user to null):

```dart
user = NoneValue(null); // forces new value.
user = user.toNone(); // DONT. this will fallback to the current value.
user = user.toNone(null); // DONT. this will fallback to the current value.
```

You can also check the state easily:

```dart
if (user is LoadingValue) { /* ... */ }
if (user is SuccessValue) { /* ... */ }
if (user is ErrorValue) { print(user.error); }
```

---

## 🤔 Why Ephemeral Value?

- **Reduce Boilerplate:** No more manual state enums or flags.
- **Consistent Patterns:** Use the same approach for all async or transient
  values.
- **Improved Readability:** Clear, self-documenting state transitions.
- **Testable:** All states are value-equal and easy to test.

---

## 📦 Pub.dev

- [ephemeral_value on pub.dev](https://pub.dev/packages/ephemeral_value)
- [API Documentation](https://pub.dev/documentation/ephemeral_value/latest/)

---

## 📝 License

[BSD 3-Clause License](https://github.com/xamantra/ephemeral_value/blob/main/LICENSE)

---

## 💡 Contributing

Contributions, issues, and feature requests are welcome!\
See [issues](https://github.com/xamantra/ephemeral_value/issues).

---

> Ephemeral Value — The easiest way to manage transient state in Dart and
> Flutter!
