import 'package:flutter/material.dart';
import 'package:enma/services/authentication.dart';
import 'package:enma/pages/root_page.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
          child: MaterialApp(
      //title: 'Flutter login demo',
            debugShowCheckedModeBanner: false,
        /*theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),*/
            home: new RootPage()));
  }
}
