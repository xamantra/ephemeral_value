# Example

## Sample state class

The state class holds the current state of your feature or screen. Here, the
`LoginState` contains an `Ephemeral<User>` to represent the user data and its
ephemeral state. By default, it starts with a `NoneValue`, and you can use
`copyWith` to update the state immutably.

```dart
class LoginState {
    final Ephemeral<User> user;

    LoginState({
        this.user = const NoneValue(null),
    });

    const LoginState copyWith({
        Ephemeral<User>? user,
    }) {
        return LoginState(
            user: user ?? this.user,
        );
    }
}
```

## Sample bloc logic

This section demonstrates how to update the state in response to asynchronous
events, such as loading a user. The state transitions through `LoadingValue`,
`SuccessValue`, and `ErrorValue` depending on the outcome of the operation.

```dart
try {
    emit(state.copyWith(user: LoadingValue(null)));
    final user = await UserRepository().getUser(event.id);
    emit(state.copyWith(user: SuccessValue(user)));
} catch (e) {
    emit(state.copyWith(user: ErrorValue(null, e)));
    // or you can also use one of the provided transition method
    emit(state.copyWith(user: state.user.toError()));
}
```

## Sample widget Code

In your widget, you can do type checks on the `Ephemeral` state to render
different UI components based on the current state of the user data. This allows
you to handle loading, success, and error states effectively.

```dart
if (state.user is LoadingValue) {
    return const CircularProgressIndicator();
} else if (state.user is SuccessValue) {
    return Text('User: ${(state.user as SuccessValue).value.name}');
} else if (state.user is ErrorValue) {
    return Text('Error: ${(state.user as ErrorValue).error}');
}
```
