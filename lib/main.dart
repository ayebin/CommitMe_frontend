import 'package:flutter/material.dart';
import 'package:commit_me/page/home.dart';
import 'package:commit_me/page/info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomePage(),
    );
  }
}