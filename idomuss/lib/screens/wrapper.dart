import 'package:flutter/material.dart';
import 'package:idomuss/screens/authenticate/authenticate.dart';
import 'package:idomuss/screens/authenticate/sign_in.dart';
import 'package:idomuss/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:idomuss/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseUser>(context);

    return user == null? SignIn(): Home();
  }
}
