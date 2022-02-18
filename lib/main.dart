// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:deriv_p2p_practice_project/features/core/presentation/pages/connection_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

/// The main widget.
class MyApp extends StatefulWidget {
  // ignore: public_member_api_docs
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Connection(),
      );
}
