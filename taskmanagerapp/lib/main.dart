import 'package:flutter/material.dart';
import 'package:taskmanagerapp/screens/homepage.dart';
import 'package:taskmanagerapp/screens/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  HomeScreen(),
    );
  }
}

