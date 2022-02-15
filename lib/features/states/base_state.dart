// import 'package:equatable/equatable.dart';

// /// States status types.
// enum StateStatus {
//   /// Determines the state is in its initial state.
//   initial,

//   /// Determines the state is in loading state, Usually when there is a server
//   /// call the status will be loading.
//   loading,

//   /// Determines the last action on state was successful. Usually when there is
//   /// a server call and the response was successful.
//   success,

//   /// Determines the last action on state was not successful. Usually when there
//   /// is a server call and the response was not successful.
//   failure,
// }

// /// This class is the base class for for bloc/cubit states. It provides some
// /// functionalities Internally. Other states should extend from this base class
// /// and provide the generic type for the data.
// class BaseState<T> extends Equatable {
//   /// Constructs a new BaseState with the given parameters.
//   const BaseState({
//     this.status = StateStatus.initial,
//     this.data,
//     this.error,
//   });

//   /// Determines the state current status.
//   final StateStatus? status;

//   /// Contains the data of the state.
//   final T? data;

//   /// Contains the error of the state.
//   final Object? error;

//   /// Returns a copy of the current state with given override parameters.
//   BaseState<T> copyWith({
//     StateStatus? status,
//     T? data,
//     Object? error,
//   }) =>
//       BaseState<T>(
//         status: status ?? this.status,
//         data: data ?? this.data,
//         error: error ?? this.error,
//       );

//   /// Resets the state to its initial status.
//   BaseState<T> initial() => BaseState<T>();

//   /// Returns a copy of the current state with loading status.
//   BaseState<T> loading() => copyWith(status: StateStatus.loading);

//   /// Returns a copy of the current state with success status and given data.
//   BaseState<T> success([T? data]) => copyWith(
//         status: StateStatus.success,
//         data: data,
//       );

//   /// Returns a copy of the current state with failure status and given error.
//   BaseState<T> failure([Object? error]) => copyWith(
//         status: StateStatus.failure,
//         error: error,
//       );

//   /// Returns true if the state contains data.
//   bool get hasData => data != null;

//   /// Returns true if the state contains error.
//   bool get hasError => error != null;

//   /// Returns true if the state [status] is equal to initial.
//   bool get isInitial => status == StateStatus.initial;

//   /// Returns true if the state [status] is equal to loading.
//   bool get isLoading => status == StateStatus.loading;

//   /// Returns true if the state [status] is equal to success.
//   bool get isSuccess => status == StateStatus.success;

//   /// Returns true if the state [status] is equal to failure.
//   bool get isFailure => status == StateStatus.failure;

//   @override
//   List<Object?> get props => <Object?>[status, data, error];
// }
