import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';
import 'package:idomuss/models/endereco.dart';
import 'package:idomuss/screens/configuracoes/addEnderecoComplementos.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:search_cep/search_cep.dart';

class AdicionarEndereco extends StatefulWidget {
  @override
  _AdicionarEnderecoState createState() => _AdicionarEnderecoState();
}

class _AdicionarEnderecoState extends State<AdicionarEndereco> {
  
  Endereco novo;
  var maskCEP = new MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  TextEditingController enderecoController;
  String cep;
  @override
  void initState() {
    super.initState();
    enderecoController = new TextEditingController(text: "");
    cep = "";
    novo = Endereco.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(elevation: 0,),
      body: SingleChildScrollView(
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: Text("Para facilitar, digite apenas o seu CEP",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSizeRegular,
                  color: ColorSys.black
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: TextFieldOutline(
                label: "CEP",
                keyboardType: TextInputType.datetime,
                inputFormatter: [maskCEP],
                onChanged: (value) {setState(() => cep = value);},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: TextFormField(
                controller: enderecoController,
                decoration: textFilled.copyWith(hintText: "Endereço",
                          prefixIcon: Icon(Icons.map),),
                readOnly: true,   
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: Container(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Calcular endereço"),
                  padding: EdgeInsets.all(paddingSmall),
                  onPressed: cep.length < 9 ? null : () {
                    getEndereco(cep, context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FlatButton(
        disabledColor: ColorSys.secundarygray,
        padding: EdgeInsets.all(paddingLarge),
        child: Text(
          "Avançar",
          style: TextStyle(color: Colors.white),
        ),
        color: ColorSys.primary,
        onPressed: enderecoController.text.isEmpty? null : (){
          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdicionarComplemento(novo),
                                    ));
        }),
    );
  }
  
  getEndereco(String cep, BuildContext ctx) async{
    cep = cep.replaceAll('-', "");
    var endereco = await ViaCepSearchCep().searchInfoByCep(cep: cep);
   
    endereco.fold(
    (exception) {
      if(exception.errorMessage.isNotEmpty)
         AwesomeDialog(
                              context: ctx,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.TOPSLIDE,
                              title: "CEP Inválido",
                              desc: "Eita! Você digitou um CEP inválido. Por favor, tente novamente!",
                              btnOkOnPress: (){},
                              )..show();
    }, 
    (tokenModel) {
      
      setState(() {
        enderecoController.text = "${tokenModel.logradouro}, ${tokenModel.localidade}";
      });
      
       novo.cidade = tokenModel.localidade;
       novo.bairro = tokenModel.bairro;
       novo.rua = tokenModel.logradouro;
       novo.uf = tokenModel.uf;
    }
    );
  }
}