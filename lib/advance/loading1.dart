import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: Container(
        height: 200.0,
        width: 200.0,
        color: Colors.white,
        child: Center(
          child: SizedBox(
            width: 150.0,
            height: 150.0,
            child: CircularProgressIndicator(
                strokeWidth: 20,
                valueColor: AlwaysStoppedAnimation<Color>
                  (Colors.blueAccent)
            ),
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