import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/screens/home_screen.dart';

void main(List<String> args) async {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen()
    );
  }
}
