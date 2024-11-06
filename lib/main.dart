import 'package:flutter/material.dart';
import 'package:tropical_ship_supply/home_page/home_page.dart';
import 'package:tropical_ship_supply/login/login_page.dart';
import 'package:tropical_ship_supply/price/price_page.dart';
import 'package:tropical_ship_supply/vessel/vessel_grid_state.dart';

String url_api = "http://localhost:3000/";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

