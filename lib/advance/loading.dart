import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SizedBox(
          width: 100.0,
          height: 100.0,
          child: CircularProgressIndicator(
            strokeWidth: 20,
            valueColor: AlwaysStoppedAnimation<Color>
              (Colors.blueAccent)
          ),
        ),
      ),
    );
      /*
      color: Colors.red[100],
      child: Center(
        child: SpinKitRotatingCircle(
          color: Colors.teal,
          size: 60.0,
          */
  }
}