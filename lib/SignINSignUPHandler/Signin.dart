import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:enma/services/authentication.dart';
import 'package:enma/advance/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';

  String password = '';

  String error = '';

  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Colors.red[50],
      body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height*1.0,
            width: MediaQuery.of(context).size.width*1.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/Front3.jpg'),
                  fit: BoxFit.fill,
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Text('Welcome to', style: TextStyle(fontSize: 30.0, color: Colors.white),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text('Enma', style: TextStyle(fontFamily: 'Sweets',fontSize: 120.0, color: Colors.white, fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 40.0),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                  decoration: new InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black87,
                                            width: 1.5,
                                            style: BorderStyle.solid
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 1.5,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      hintText: 'Email',
                                      hintStyle: TextStyle(fontFamily: 'SFDisplay',
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                      prefixIcon: Icon(Icons.mail, color: Colors.red,)
                                  ),
                                  validator: (val) => val.isEmpty ? 'Enter an email' : null,
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  },
                                ),
                                SizedBox(height: 25.0),
                                TextFormField(
                                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                                  obscureText: _obscureText,
                                  decoration: new InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black87,
                                            width: 1.5,
                                            style: BorderStyle.solid
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 1.5,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      hintText: 'Password',
                                      hintStyle: TextStyle(fontFamily: 'SFDisplay',
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                      prefixIcon: Icon(Icons.lock, color: Colors.red),
                                      suffixIcon: IconButton(
                                        onPressed: _toggleVisibility,
                                        icon: _obscureText
                                            ? Icon(Icons.visibility_off)
                                            : Icon(Icons.visibility),
                                      )
                                  ),
                                  validator: (val) =>
                                  val.length < 6
                                      ? 'Password must be at least  6 characters'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  },
                                ),
                                SizedBox(height: 30.0),
                                ButtonTheme(
                                  height: 55,
                                  minWidth: 360,
                                  child: RaisedButton(
                                    elevation: 5.0,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(3.5)
                                    ),
                                    color: Colors.deepPurple,
                                    child: Text(
                                      'LOG IN',
                                      style: new TextStyle(fontSize: 20.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .signInWithEmailAndPassword(email, password);
                                        if (result == null) {
                                          setState(() {
                                            error =
                                            'could not sign in with those credentials';
                                            loading = false;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                FlatButton(
                                  onPressed: widget.toggleView,
                                  child: Text(
                                      'Create an Account if you\'re new',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600
                                      )
                                  ),
                                ),
                                Text(
                                  error,
                                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                                )
                              ],
                            ),
                          )),
                    ),
                ],

              ),
            ),
          )
      ),
    );
  }
}
