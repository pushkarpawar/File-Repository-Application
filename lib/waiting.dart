import 'package:flutter/material.dart';

// ignore: camel_case_types
class waitingPage extends StatefulWidget {
  waitingPage({Key key}) : super(key: key);

  @override
  _waitingPageState createState() => _waitingPageState();
}

// ignore: camel_case_types
class _waitingPageState extends State<waitingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: CircularProgressIndicator(backgroundColor: Colors.black),
        ),
      ),
    );
  }
}