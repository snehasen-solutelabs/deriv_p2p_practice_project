import 'package:deriv_p2p_practice_project/features/core/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

/// The main widget.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Dashboard(),
        theme: ThemeData(
          primaryColor: Colors.black,
          //primarySwatch: Colors.black,
        ),
      );
}
