import 'package:flutter/material.dart';
import 'dart:io';

void main() => runApp(AppDashBoard());

class AppDashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Solution",
      theme: ThemeData(
        primaryColor: Color(0xFF03254E),
        accentColor: Color(0xFF545677)
      ),
      home: Scaffold(
        body: DashBoard(),
        appBar: AppBar(
          title: Text("Cargo Dashboard"),
          centerTitle: Platform.isIOS?true:false,
          actions: <Widget>[
            InkWell(child: Container(child: Icon(Icons.autorenew), margin: EdgeInsets.only(right: 20),)),
          ],
        ),
      ),

    );
  }
}

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}