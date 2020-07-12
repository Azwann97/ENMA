import 'package:flutter/material.dart';
import 'package:enma/SignINSignUPHandler/Signup.dart';
import 'package:enma/SignINSignUPHandler/Signin.dart';

class Handler extends StatefulWidget {
  @override
  _HandlerState createState() => _HandlerState();
}

class _HandlerState extends State<Handler> {

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn  = !showSignIn );
  }
  @override
  Widget build(BuildContext context) {
    if ( showSignIn) {
      return SignIn(toggleView: toggleView);
    }  else {
      return SignUp(toggleView: toggleView);
    }
  }
}