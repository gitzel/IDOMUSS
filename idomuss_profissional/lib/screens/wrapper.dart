import 'package:flutter/material.dart';
import 'package:idomussprofissional/screens/authenticate/sign_in.dart';
import 'package:idomussprofissional/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return user == null ? SignIn() : Home();
  }
}
