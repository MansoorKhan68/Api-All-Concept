import 'package:api_course/pages/Exampe_2.dart';
import 'package:api_course/pages/example_1.dart';
import 'package:api_course/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Example2(),);
  }
}
