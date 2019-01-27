import 'package:flutter/material.dart';
import 'dart:io';

void main() => runApp(ClientApp());

class ClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Delta Cargo Truck",
      theme: ThemeData(
        primaryColor: Color(0xFF03254E),
        textSelectionColor: Color(0xFF545677),
        accentColor: Color(0xFF545677)
      ),
      home: Scaffold(
        backgroundColor: Color(0xFF3B4975),
        appBar: AppBar(
          title: Text("Truck"),
          centerTitle: Platform.isIOS?true:false,
        ),
        body: LayoutWidget(),
      ),
      
    );
  }
}

class LayoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
