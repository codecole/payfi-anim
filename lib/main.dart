import 'package:flutter/material.dart';
import 'package:payfi_anim/anim.dart';
import 'package:payfi_anim/anim2.dart';
import 'package:payfi_anim/anim_sample.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: AnimSample(),
      home: Anim(),
    );
    // home: Trial2());
  }
}
