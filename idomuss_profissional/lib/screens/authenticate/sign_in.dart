import 'package:flutter/material.dart';
import 'package:idomussprofissional/components/textFieldOutline.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/screens/authenticate/register.dart';
import 'package:idomussprofissional/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String error = '';
  bool escondeSenha = true;
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.topLeft,
        decoration: background,
        child: Padding(
          padding: const EdgeInsets.all(paddingSmall),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: new TextSpan(
                  style: new TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: ColorSys.black),
                  children: <TextSpan>[
                    TextSpan(text: 'Olá\nBem vindo'),
                    TextSpan(
                        text: '!', style: TextStyle(color: ColorSys.primary)),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: paddingMedium, bottom: paddingSmall),
                      child: TextFieldOutline(
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        label: 'Email',
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: paddingTiny, bottom: paddingLarge),
                      child: TextFieldOutline(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: escondeSenha,
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                            icon: escondeSenha
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                escondeSenha = !escondeSenha;
                              });
                            }),
                        label: 'Senha',
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: paddingLarge),
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                            padding: EdgeInsets.all(paddingSmall),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSizeRegular),
                            ),
                            color: ColorSys.primary,
                            onPressed: () {
                              AuthService auth = AuthService();
                              auth.signIn(email.trim(), password);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: RaisedButton.icon(
                          icon: ImageIcon(
                            AssetImage("assets/geral/google_icon.ico"),
                            color: ColorSys.primary,
                          ),
                          label: Text(
                            'Entrar com o google',
                            style: TextStyle(
                              color: ColorSys.primary,
                              fontSize: fontSizeRegular,
                            ),
                          ),
                          color: ColorSys.gray,
                          onPressed: () async {
                            dynamic result = _auth.signInWithGoogle();
                            if (result == null) {
                              // modal
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                  color: ColorSys.primary, width: 2.0))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(paddingSmall),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: RichText(
                          text: new TextSpan(
                            style: new TextStyle(
                                fontSize: fontSizeSmall,
                                fontFamily: 'Montserrat',
                                color: ColorSys.black,
                                backgroundColor: ColorSys.gray),
                            children: <TextSpan>[
                              TextSpan(text: 'Novo no app?'),
                              TextSpan(
                                  text: ' Registre-se agora!',
                                  style: TextStyle(color: ColorSys.primary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
