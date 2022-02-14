part of 'internet_bloc.dart';

abstract class InternetEvent {}

class Offline extends InternetEvent {
  String toString() => 'InternetEvent(Offline)';
}

class Online extends InternetEvent {
  String toString() => 'InternetEvent(Online)';
}

class SocketConnected extends InternetEvent {
  String toString() => 'InternetEvent(SocketConnected)';
}

class SocketDisconnected extends InternetEvent {
  String toString() => 'InternetEvent(SocketDisconnected)';
}
