import 'package:flutter/material.dart';

class TitledWidget extends StatelessWidget {
  final String text;
  final Widget widget;
  
  TitledWidget({@required this.text, @required this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(text),
        widget
      ],
    );
  }
}