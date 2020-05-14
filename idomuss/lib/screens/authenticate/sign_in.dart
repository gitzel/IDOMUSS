import 'package:flutter/material.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/services/auth.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text("Sign in to Idomuss"),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Register'))
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val) => val.isEmpty? 'Enter an email':null,
                    onChanged: (val){
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val) => val.length < 8 ? 'Enter a password 8+ char long':null,
                    obscureText: true,
                    onChanged: (val){
                        setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async{
                      dynamic result = _auth.signIn(email, password);
                      if(result == null) {
                        setState(() => error = 'could not sign in with those credentials');
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red[400], fontSize: 14.0),
                  ),
                ],
            ),
          ),
      ),
    );
  }
}
