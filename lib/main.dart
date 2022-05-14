import 'package:flutter/material.dart';
import 'package:to_do_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.purple),
          errorColor: Colors.purple),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
