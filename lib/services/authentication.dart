/*
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;

  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    //create collection document
    //await DatabaseServices(uid: user.uid).updateUserData('5th october 2020', 'Ledang Hiking', 'Gunung Ledang');
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:enma/models/newUser.dart';
import 'package:enma/models/user.dart';
import 'package:enma/services/UserDBHandler.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  NewUser _currentUser;
  NewUser get currentUser => _currentUser;

  // create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  // sign in anonymously
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future registerWithEmailAndPassword(String email, String password, String name, String UiTM_ID, String gender, String UT, String phoneNo, String Fac) async {

    try {
      // create user authenticate
      AuthResult result = await _auth.createUserWithEmailAndPassword(email:email, password: password);
      FirebaseUser user = result.user;
      String UP;
      //create user profile
      _currentUser = NewUser(
        id: result.user.uid,
        email: email,
        name: name,
        ID: UiTM_ID,
        gender: gender,
        userType: UT,
        PNo: phoneNo,
        Faculty: Fac,
        UP: "",
        UImage: "https://firebasestorage.googleapis.com/v0/b/enma-2d0a9.appspot.com/o/blank_portrait-350x350.png?alt=media&token=1d10269f-3c6b-4831-b446-be408c5accc1",

      );
      await DatabaseService().createUser(_currentUser);
      //await DatabaseService().createUser(_currentUser);
      return _userFromFirebaseUser(user);
    }  catch(e) {
      print(e.toString());
      return null;
    }
  }
  Future registerEOWithEmailAndPassword(String email, String password, String name, String UiTM_ID, String gender, String UT, String phoneNo, String Fac) async {
    try {

      // create user authenticate
      AuthResult result = await _auth.createUserWithEmailAndPassword(email:email, password: password);
      FirebaseUser user = result.user;

      //create user profile
      _currentUser = NewUser(
        id: result.user.uid,
        email: email,
        name: name,
        ID: UiTM_ID,
        gender: gender,
        userType: UT,
        PNo: phoneNo,
        Faculty: Fac,
      );
      await DatabaseService().createOrganizer(_currentUser);
      //await DatabaseService().createUser(_currentUser);
      return _userFromFirebaseUser(user);
    }  catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future signInWithEmailAndPassword( String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email:email, password: password);
      FirebaseUser user = result.user;

      //  create a new document for the user with the uid
      //  await  DatabaseService(uid: user.uid, email: user.email).updateUserData('New User', 'Not set', 'Not set');
      return _userFromFirebaseUser(user);
    }  catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    }  catch(e){
      print(e.toString());
      return null;
    }
  }

}