import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'CheckLogin.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => const HomePage()},
  ));
}
