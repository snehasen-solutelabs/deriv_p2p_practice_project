import 'package:flutter/material.dart';

enum ConnectionType {
  wifi,
  mobile,
}

@immutable
abstract class InternetState {}

class InternetConnectionTypeLoading extends InternetState {}

class InternetConnectionType extends InternetState {
  final ConnectionType? connectionType;

  InternetConnectionType({required this.connectionType});
}
