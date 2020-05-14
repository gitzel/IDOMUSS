import 'package:flutter/material.dart';
import 'package:idomuss/services/auth.dart';
import 'package:idomuss/models/cliente.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

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
        title: Text("Sign up to Idomuss"),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Sign In'))
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
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                      dynamic result = _auth.signUp(email, password,
                          Cliente('1891293',
                              '2479349739',
                              'Isabela',
                              '178237821',
                              '15/06/2003',
                              'Feminino',
                              1,
                              'sou linda', null, null));
                      if(result == null) {
                          setState(() => error = 'please support a valid email');
                      }
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
    );;
  }
}
