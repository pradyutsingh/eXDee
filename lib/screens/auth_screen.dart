import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:Exdee/widgets/authform.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isloading = false;
  final _auth = FirebaseAuth.instance;
  void _submitAuthForm(String email, String password, String userName,
      bool isLogin, File image, BuildContext ctx) async {
    AuthResult authResult;

    try {
      setState(() {
        _isloading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final storageref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');

        await storageref.putFile(image).onComplete;
        final imgurl = await storageref.getDownloadURL();

        
        await Firestore.instance
            .collection('users')  
            .document(authResult.user.uid)
            .setData({'username': userName, 'email': email , 'image_url' : imgurl});
      }
    } on PlatformException catch (error) {
      var message = 'An error occured,please check your credentials';
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ));
      setState(() {
        _isloading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF0A0E21),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 95),
                Text(
                  'XD',
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 90,
                      fontWeight: FontWeight.w900),
                ),
                AuthForm(_submitAuthForm, _isloading)
              ],
            ),
          ),
        ));
  }
}
