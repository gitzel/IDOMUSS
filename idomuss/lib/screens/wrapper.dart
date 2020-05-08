import 'package:flutter/material.dart';
import 'package:idomuss/screens/authenticate/authenticate.dart';
import 'package:idomuss/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:idomuss/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return user == null? Authenticate(): Home();
  }
}
