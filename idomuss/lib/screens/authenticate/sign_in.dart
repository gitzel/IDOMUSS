import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
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
  bool escondeSenha = true;
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/geral/bg.png'), fit: BoxFit.none),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                          fontSize: 48.0,
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
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            style: TextStyle(fontFamily: 'Montserrat'),
                            validator: (val) =>
                                val.isEmpty ? 'Email inválido!' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 48),
                          child: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: escondeSenha,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: escondeSenha
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      escondeSenha = !escondeSenha;
                                    });
                                  },
                                ),
                                labelText: 'Senha',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            style: TextStyle(fontFamily: 'Montserrat'),
                            validator: (val) =>
                                val.isEmpty ? 'Senha inválida!' : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 32),
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: RaisedButton(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'Montserrat'),
                                ),
                                color: ColorSys.primary,
                                onPressed: () {},
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
                                    fontSize: 18,
                                    fontFamily: 'Montserrat'),
                              ),
                              clipBehavior: Clip.hardEdge,
                              color: ColorSys.gray,
                              onPressed: () async {
                                dynamic result = _auth.signIn(email, password);
                                if (result == null){
                                  setState(() => error = 'could not sign in with those credentials');
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      color: ColorSys.primary, width: 2.0))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: (){},
                            child: RichText(
                              text: new TextSpan(
                                style: new TextStyle(
                                    fontSize: 14.0,
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
  /*@override
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
                  validator: (val) => val.length < 8 ? 'Enter a password 8+ char long' :null, obscureText: true,
                    onChanged: (val){ setState(()=> password = val);
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
                    }*/
}
