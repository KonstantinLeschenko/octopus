import 'package:flutter/material.dart';

class MySquare extends StatelessWidget {

  final color;
  final child;

  MySquare({this.color, this.child});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.0),
        child: (Container(
          color: color,
          child: child,
        )),
      ),
    );
  }

}