import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_telefone.dart';
import 'package:idomuss/services/auth.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  Register();

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  Cliente cliente;
  bool valorValido;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    cliente = new Cliente.empty();
    valorValido = false;
    super.initState();
  }

  @override
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorSys.primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'Qual é o seu email?',
                  style: TextStyle(
                      color: ColorSys.black,
                      fontFamily: 'Montserrat',
                      fontSize: 18),
                ),
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (val) =>
                      !EmailValidator.validate(val) ? 'Email inválido!' : null,
                  onChanged: (val) {
                    setState(() {
                      if (_formKey.currentState.validate()) {
                        cliente.email = val;
                        valorValido = true;
                      } else {
                        valorValido = false;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FlatButton(
        disabledColor: Colors.grey[400],
        padding: EdgeInsets.all(24),
        child: Text(
          'Continuar',
          style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
        ),
        color: ColorSys.primary,
        onPressed: valorValido
            ? () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroTelefone(
                        cliente: cliente,
                      ),
                    ));
              }
            : null,
      ),
    );
  }
}
