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
- **Extension Methods:** Convenient getters and type checking methods.
- **Message Support:** Optional messages for better state context.

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

### Basic State Types

Ephemeral value types represent different states of a value:

- `NoneValue()` or `NoneValue("Jane Doe")`: Initial nullable value (optional).
- `InitialValue(guestUser)`: Initial non-null value.
- `LoadingValue()`: Loading state (optional value).
- `SuccessValue(userObj)`: Loaded successfully (non-null value).
- `ErrorValue(null, errorObj)`: Error state (optional value, error object).
- `EmptyValue()`: Loaded but empty or null.
- `RefreshingValue()`: Background refresh state.
- `StaleValue()`: Outdated but available data.

### Example: State Class

```dart
class LoginState {
  final Ephemeral<User> user;
  final Ephemeral<List<Post>> posts;

  LoginState({
    this.user = const NoneValue(),
    this.posts = const NoneValue(),
  });

  LoginState copyWith({
    Ephemeral<User>? user,
    Ephemeral<List<Post>>? posts,
  }) {
    return LoginState(
      user: user ?? this.user,
      posts: posts ?? this.posts,
    );
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
Widget buildUserWidget(Ephemeral<User> user) {
  if (user.isLoading) {
    return const CircularProgressIndicator();
  } else if (user.isSuccess) {
    return Text('User: ${user.getSuccess.name}');
  } else if (user.isError) {
    return Text('Error: ${user.getError}');
  } else if (user.isEmpty) {
    return const Text('No user found');
  } else {
    return const Text('Initial state');
  }
}
```

---

## 📚 Complete API Reference

### Core Classes

#### `Ephemeral<T>`
Abstract base class for all ephemeral value types.

**Properties:**
- `T? value` - The underlying value (nullable)

**Transition Methods:**
- `toNone([T? value])` - Transition to `NoneValue`
- `toInitial([T? value, String? message])` - Transition to `InitialValue`
- `toLoading([T? value, String? message])` - Transition to `LoadingValue`
- `toSuccess([T? value, String? message])` - Transition to `SuccessValue`
- `toError([T? value, Object? error])` - Transition to `ErrorValue`
- `toEmpty([T? value, String? message])` - Transition to `EmptyValue`
- `toRefreshing([T? value, String? message])` - Transition to `RefreshingValue`
- `toStale([T? value, DateTime? lastUpdated, String? message])` - Transition to `StaleValue`

#### `NoneValue<T>`
Represents an initial nullable value.

```dart
const NoneValue()           // Null initial value
const NoneValue("Jane Doe")     // With initial value
```

#### `InitialValue<T>`
Represents an initial non-null value.

```dart
const InitialValue(user)                    // With value only
const InitialValue(user, "Initial user")    // With value and message
```

#### `LoadingValue<T>`
Represents a loading state.

```dart
const LoadingValue()                        // No value, no message
const LoadingValue(user)                    // With previous value
const LoadingValue(user, "Loading...")     // With value and message
```

#### `SuccessValue<T>`
Represents a successfully loaded value.

```dart
const SuccessValue(user)                    // With value only
const SuccessValue(user, "Loaded successfully") // With value and message
```

#### `ErrorValue<T>`
Represents an error state.

```dart
const ErrorValue()                          // No value, no error
const ErrorValue(null, exception)          // With error only
const ErrorValue(user, exception)          // With previous value and error
```

#### `EmptyValue<T>`
Represents an empty or null result.

```dart
const EmptyValue()                          // No value, no message
const EmptyValue(null, "No data found")    // With message
```

#### `RefreshingValue<T>`
Represents a background refresh state.

```dart
const RefreshingValue()                     // No value, no message
const RefreshingValue(user, "Refreshing...") // With value and message
```

#### `StaleValue<T>`
Represents outdated but available data.

```dart
const StaleValue(user)                     // With value only
const StaleValue(user, DateTime.now())     // With value and timestamp
const StaleValue(user, DateTime.now(), "Data is stale") // Complete
```

### Extension Methods

The library provides convenient extension methods for type checking and value extraction:

#### Type Checking
```dart
ephemeral.isNone        // bool
ephemeral.isInitial     // bool
ephemeral.isLoading     // bool
ephemeral.isSuccess     // bool
ephemeral.isError       // bool
ephemeral.isEmpty       // bool
ephemeral.isRefreshing  // bool
ephemeral.isStale       // bool
```

#### Value Extraction
```dart
ephemeral.getNone       // T? (throws if not NoneValue)
ephemeral.getInitial    // T (throws if not InitialValue)
ephemeral.getLoading    // T? (throws if not LoadingValue)
ephemeral.getSuccess    // T (throws if not SuccessValue)
ephemeral.getError      // Object? (throws if not ErrorValue)
ephemeral.getEmpty      // T? (throws if not EmptyValue)
ephemeral.getRefreshing // T? (throws if not RefreshingValue)
ephemeral.getStale      // T? (throws if not StaleValue)
```

#### Message Extraction
```dart
ephemeral.getInitialMessage    // String? (throws if not InitialValue)
ephemeral.getLoadingMessage    // String? (throws if not LoadingValue)
ephemeral.getSuccessMessage    // String? (throws if not SuccessValue)
ephemeral.getEmptyMessage      // String? (throws if not EmptyValue)
ephemeral.getRefreshingMessage // String? (throws if not RefreshingValue)
ephemeral.getStaleMessage      // String? (throws if not StaleValue)
```

#### Special Getters
```dart
ephemeral.getStaleLastUpdated  // DateTime? (throws if not StaleValue)
```

---

## 🛠️ Advanced Usage Examples

### State Management with BLoC

```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {
    on<LoadUser>(_onLoadUser);
    on<RefreshUser>(_onRefreshUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    try {
      // Start loading
      emit(state.copyWith(user: state.user.toLoading()));
      
      final user = await userRepository.getUser(event.id);
      
      if (user == null) {
        emit(state.copyWith(user: state.user.toEmpty()));
      } else {
        emit(state.copyWith(user: state.user.toSuccess(user)));
      }
    } catch (e) {
      emit(state.copyWith(user: state.user.toError(null, e)));
    }
  }

  Future<void> _onRefreshUser(RefreshUser event, Emitter<UserState> emit) async {
    try {
      // Keep current value while refreshing
      emit(state.copyWith(user: state.user.toRefreshing()));
      
      final user = await userRepository.getUser(event.id);
      emit(state.copyWith(user: state.user.toSuccess(user)));
    } catch (e) {
      // Keep current value on error
      emit(state.copyWith(user: state.user.toError(null, e)));
    }
  }
}
```

### Flutter Widget with Complete State Handling

```dart
class UserProfileWidget extends StatelessWidget {
  final Ephemeral<User> user;

  const UserProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildUserContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserContent() {
    if (user.isLoading) {
      return const Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text('Loading user...'),
        ],
      );
    }

    if (user.isSuccess) {
      final userData = user.getSuccess;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${userData.name}'),
          Text('Email: ${userData.email}'),
          if (user.getSuccessMessage != null)
            Text(
              user.getSuccessMessage!,
              style: const TextStyle(color: Colors.green),
            ),
        ],
      );
    }

    if (user.isError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error, color: Colors.red),
          Text('Error: ${user.getError}'),
          if (user.value != null)
            Text('Previous data may be available'),
        ],
      );
    }

    if (user.isEmpty) {
      return Column(
        children: [
          const Icon(Icons.person_off, color: Colors.grey),
          Text(user.getEmptyMessage ?? 'No user found'),
        ],
      );
    }

    if (user.isRefreshing) {
      return Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Refreshing...'),
                if (user.value != null)
                  Text('Current data: ${user.value!.name}'),
              ],
            ),
          ),
        ],
      );
    }

    if (user.isStale) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning, color: Colors.orange),
              const SizedBox(width: 8),
              Text('Data may be outdated'),
            ],
          ),
          Text('Name: ${user.getStale.name}'),
          Text('Last updated: ${user.getStaleLastUpdated}'),
          if (user.getStaleMessage != null)
            Text(user.getStaleMessage!),
        ],
      );
    }

    // Initial state
    return const Text('No user data');
  }
}
```

### Complex State Management

```dart
class DashboardState {
  final Ephemeral<User> currentUser;
  final Ephemeral<List<Post>> posts;
  final Ephemeral<Analytics> analytics;

  DashboardState({
    this.currentUser = const NoneValue(),
    this.posts = const NoneValue(),
    this.analytics = const NoneValue(),
  });

  DashboardState copyWith({
    Ephemeral<User>? currentUser,
    Ephemeral<List<Post>>? posts,
    Ephemeral<Analytics>? analytics,
  }) {
    return DashboardState(
      currentUser: currentUser ?? this.currentUser,
      posts: posts ?? this.posts,
      analytics: analytics ?? this.analytics,
    );
  }

  bool get isLoading => 
    currentUser.isLoading || posts.isLoading || analytics.isLoading;

  bool get hasError => 
    currentUser.isError || posts.isError || analytics.isError;

  String? get errorMessage {
    if (currentUser.isError) return 'User: ${currentUser.getError}';
    if (posts.isError) return 'Posts: ${posts.getError}';
    if (analytics.isError) return 'Analytics: ${analytics.getError}';
    return null;
  }
}
```

### Transition Patterns

```dart
// Pattern 1: Force new value
Ephemeral<User> user = NoneValue();
user = NoneValue(newUser); // Forces new value

// Pattern 2: Retain current value
user = user.toLoading(); // Keeps current value, changes state

// Pattern 3: Conditional transitions
if (user.isSuccess) {
  user = user.toRefreshing(); // Keep success value while refreshing
} else {
  user = user.toLoading(); // Start fresh loading
}

// Pattern 4: Error handling with value retention
try {
  user = user.toLoading();
  final newUser = await fetchUser();
  user = user.toSuccess(newUser);
} catch (e) {
  user = user.toError(null, e); // Keep current value, add error
}
```

---

## 🤔 Why Ephemeral Value?

- **Reduce Boilerplate:** No more manual state enums or flags.
- **Consistent Patterns:** Use the same approach for all async or transient
  values.
- **Improved Readability:** Clear, self-documenting state transitions.
- **Testable:** All states are value-equal and easy to test.
- **Type Safe:** Compile-time guarantees for state transitions.
- **Extensible:** Easy to add new state types if needed.

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
