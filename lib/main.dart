import 'package:flutter/material.dart';
import 'AlQuran.dart';

void main() {
  runApp(MaterialApp (
    debugShowCheckedModeBanner: false,
    title: "Al-Quran",
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AlQuran",
      home: AlQuran(),
    );
  }
}