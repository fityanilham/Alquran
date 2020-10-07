import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp (
    title: "Al-Quran",
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AlQuran",
      home: AlQuran(),
    );
  }
}