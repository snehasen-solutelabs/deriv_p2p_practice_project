part of 'internet_bloc.dart';

class InitialState extends InternetState {
  @override
  String toString() => 'InternetState(InitialState)';
}

class Connected extends InternetState {
  @override
  String toString() => 'InternetState(Connected)';
}

class Disconnected extends InternetState {
  final bool isWebSocketClosed;
  Disconnected({this.isWebSocketClosed = false});
  @override
  String toString() => 'InternetState(Disconnected)';
}

abstract class InternetState {}
