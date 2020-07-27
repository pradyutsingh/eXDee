import 'package:Exdee/widgets/pickers/imgpicker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  final bool isloading;
  AuthForm(this.submitFn, this.isloading);
  final void Function(String email, String password, String userName,
      bool isLogin,File image, BuildContext context) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File userImageFile;
  void _pickedImage(File image) {
    userImageFile = image;
  }

  //key is used to access the validators and the line of code below will be used to trigger the validators
  void _trySubmit() {
    final isValid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (userImageFile == null && !isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image'),
        backgroundColor: Colors.redAccent,
      ));
    }

    if (isValid) {
      _formkey.currentState.save();
      widget.submitFn(_userEmail, _userPassword, _userName, isLogin,userImageFile, context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  key: ValueKey('email'),
                  cursorColor: Colors.redAccent,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email :', hoverColor: Colors.redAccent),
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _userEmail = value;
                  },
                ),
                if (!isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    decoration: InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value.isEmpty || value.length <= 4) {
                        return 'Please enter a username more than 4 characters';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length <= 7) {
                      return 'Enter a strong password';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _userPassword = value;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                if (widget.isloading) CircularProgressIndicator(),
                if (!widget.isloading)
                  RaisedButton(
                    color: Colors.redAccent,
                    child: Text(isLogin ? 'Login' : 'Signup'),
                    onPressed: _trySubmit,
                  ),
                if (!widget.isloading)
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(isLogin
                        ? 'Create new account'
                        : 'I already have an account'),
                    color: Colors.redAccent,
                  )
              ],
            )),
      ),
    );
  }
}
