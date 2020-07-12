import 'package:enma/pages/EventOrganizer/AddEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enma/services/authentication.dart';
import 'package:enma/advance/loading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SignUp extends StatefulWidget {

  final Function toggleView;
  SignUp({ this.toggleView });

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  // Initially password is obscure
  bool _obscureText = true;

  // text field state
  String email = '' ;
  String password = '' ;
  String name = '' ;
  String UiTM_ID = '' ;
  String gender;
  String UT;
  String Fac;
  String phoneNo;
  String error = '';
  String _selectedType;
  String _selectedGender;
  String _selectedFaculty;

  List <String> genderList = <String> ['Male','Female'];
  List <String> userType = <String> ['Normal User','Event Organizer'];
  List <String> faculty = <String> ['FSKM','FPA'];

  // Toggles the password show status
  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      //backgroundColor: Colors.red[50],
      body:SingleChildScrollView(
          //padding: EdgeInsets.fromLTRB(30.0, 70.0,30.0, 5.0),
          child: Container(
            height: MediaQuery.of(context).size.height*1.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/Front3.jpg'),
                  fit: BoxFit.fitHeight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.0, 70.0,30.0, 5.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Sign Up', style: TextStyle( fontFamily: 'Sweets', fontSize: 60.0, color: Colors.white))
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      keyboardType:  TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: new InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black54,
                                width: 1.5,
                                style: BorderStyle.solid
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                          prefixIcon: Icon(Icons.mail, color: Colors.red,)
                      ),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      obscureText: _obscureText,
                      decoration: new InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black54,
                                width: 1.5,
                                style: BorderStyle.solid
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                          prefixIcon: Icon(Icons.lock, color: Colors.red),
                          suffixIcon: IconButton(
                            onPressed: _toggleVisibility,
                            icon: _obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                          )
                      ),
                      validator: (val) => val.length < 6 ? 'Password must be at least  6 characters' : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType:  TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: new InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black54,
                                width: 1.5,
                                style: BorderStyle.solid
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: 'Name',
                          hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                          prefixIcon: Icon(Icons.account_circle, color: Colors.red,)
                      ),
                      validator: (val) => val.isEmpty ? 'Enter name' : null,
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType:  TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: new InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black54,
                                width: 1.5,
                                style: BorderStyle.solid
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: 'Contact Number',
                          hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                          prefixIcon: Icon(Icons.phone, color: Colors.red,)
                      ),
                      validator: (val) => val.isEmpty ? 'Enter your contact number' : null,
                      onChanged: (val) {
                        setState(() => phoneNo = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType:  TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: new InputDecoration(

                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black54,
                                width: 1.5,
                                style: BorderStyle.solid
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: 'Student / Staff id',
                          hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                          prefixIcon: Icon(FontAwesomeIcons.addressCard, color: Colors.red,)
                      ),
                      validator: (val) => val.isEmpty ? 'Enter Student / Staff id' : null,
                      onChanged: (val) {
                        setState(() => UiTM_ID = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.all(0.2),                                                                                        // spacing outside border
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3.5),        // spacing inside border
                      //padding: EdgeInsets.symmetric(horizontal: 73, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3.5),
                        border: Border.all(
                            color: Colors.black54,
                            style: BorderStyle.solid,
                            width: 1.5),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('Please your gender', style: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey)),

                        value: _selectedGender,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedGender = newValue;
                            gender = _selectedGender;
                          });
                        },
                        items: genderList.map((gender) {
                          return DropdownMenuItem(
                            child: new Text(gender),
                            value: gender,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.all(0.2),                                                                                        // spacing outside border
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3.5),        // spacing inside border
                      //padding: EdgeInsets.symmetric(horizontal: 73, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3.5),
                        border: Border.all(
                            color: Colors.black54,
                            style: BorderStyle.solid,
                            width: 1.5),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('Type of account that you want to register', style: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey)),

                        value: _selectedType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedType = newValue;
                            UT = _selectedType;
                          });
                        },
                        items: userType.map((UT) {
                          return DropdownMenuItem(
                            child: new Text(UT),
                            value: UT,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.all(0.2),                                                                                        // spacing outside border
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3.5),        // spacing inside border
                      //padding: EdgeInsets.symmetric(horizontal: 73, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3.5),
                        border: Border.all(
                            color: Colors.black54,
                            style: BorderStyle.solid,
                            width: 1.5),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('Faculty', style: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey)),

                        value: _selectedFaculty,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedFaculty = newValue;
                            Fac = _selectedFaculty;
                          });
                        },
                        items: faculty.map((fac) {
                          return DropdownMenuItem(
                            child: new Text(fac),
                            value: fac,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ButtonTheme(
                      height: 55,
                      minWidth: 360,
                      child: RaisedButton(
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(3.5)
                          ),
                          color: Colors.deepPurple,
                          child: Text( 'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              //gender = _selectedType;
                                dynamic result = await _auth
                                    .registerWithEmailAndPassword(email, password,name,UiTM_ID,gender,UT,phoneNo,Fac);
                                if (result == null) {
                                  setState(() {
                                    error = 'Please suppy a valid email';
                                    loading = false;
                                  } );
                                }
                              /*
                              dynamic result = await _auth
                                  .registerEOWithEmailAndPassword(email, password,name,UiTM_ID,gender,UT,phoneNo);
                              if (result == null) {
                                setState(() {
                                  error = 'Please suppy a valid email';
                                  loading = false;
                                } );
                              }*/
                            }
                          }
                      ),
                    ),
                    SizedBox(height: 20.0),
                    FlatButton(
                      onPressed: widget.toggleView,
                      child: Text(
                          'Already have Account ?',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600
                          )
                      ),
                    ),
                    SizedBox(height: 12.0),
                  ],
                )),
            ),
          )
      ),
    );
  }
}
