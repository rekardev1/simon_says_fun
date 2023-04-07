import 'package:flutter/material.dart';

import 'package:simon_says_fun/screens/SimonSaysApp.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const SimonSaysApp(),
    routes: {},
  ));
}
