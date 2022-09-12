import 'package:flutter/material.dart';
import 'package:weather_app/homeSceen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        scaffoldBackgroundColor: Colors.blueGrey,
        primaryColor: Colors.blueGrey,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ),
      ),
      home: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            title: Text("WEATHER "),
            centerTitle: true,
          ),
          body: HomeScreen(),
        ),
      ),
    );
  }
}
