import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:idomussprofissional/components/radio_button.dart';
import 'package:idomussprofissional/components/textFieldOutline.dart';
import 'package:idomussprofissional/components/titulo_cadastro.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomussprofissional/screens/authenticate/cadastro/cadastro_descricao.dart';
import 'package:idomussprofissional/services/database.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;

class CadastroLimite extends StatefulWidget {
  Profissional profissional;
  CadastroLimite({this.profissional});

  @override
  _CadastroLimiteState createState() => _CadastroLimiteState();
}

class _CadastroLimiteState extends State<CadastroLimite> {
  
  RangeValues rangeValues;
  RangeLabels rangeLabels;
  TextEditingController minimo, maximo;
  @override
  void initState() {
    super.initState();
    rangeValues = RangeValues(0,300);
    rangeLabels = RangeLabels('0','300');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: DatabaseService().ListaServicos,
      builder: (context, snapshot) {

        if(!snapshot.hasData)
          return Scaffold(body: LoadPage(),);

        snapshot.data.sort();
        return CadastroScaffold(
          <Widget>[
            BackButton(
              color: ColorSys.primary,
            ),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextCadastro('Qual a faixa de custos dos seus serviços?'),
                  Padding(
                    padding: const EdgeInsets.only(top:paddingLarge),
                    child: RangeSlider(
                      min: 0,
                      max: 300,
                      values: rangeValues,
                      divisions: 30,
                      labels: rangeLabels,
                      onChanged: (values) {
                      setState(() {
                        rangeValues =values;
                        rangeLabels = RangeLabels("R\$${values.start.toInt().toString()}", "R\$${values.end.toInt().toString()}");
                        minimo = TextEditingController.fromValue(new TextEditingValue(text: values.start.toInt().toString()));
                        maximo = TextEditingController.fromValue(new TextEditingValue(text: values.end.toInt().toString()));
                      });
                    },
                    ),
                    
                  ),
                  TextCadastro('Você pode ajustar por aqui também!'),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: paddingSmall),
                    child: TextFieldOutline(
                    prefixIcon: Icons.monetization_on,
                    label: 'Valor mínimo',
                    keyboardType: TextInputType.number,
                    validator: (val) => val.length > 0 ? null : "Nome inválido!",
                    onChanged: (val) {
                      setState(() {
                          rangeValues = RangeValues(double.parse(val.toString()), rangeValues.end);
                      });
                    },
                    controller: minimo,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: paddingSmall),
                    child: TextFieldOutline(
                    prefixIcon: Icons.monetization_on,
                    label: 'Valor máximo',
                    keyboardType: TextInputType.number,
                    validator: (val) => int.parse(val) >= 0 ? null : "Numéro inválido!",
                    onChanged: (val) {
                      setState(() {
                        if(int.parse(val) > rangeValues.start)
                          rangeValues = RangeValues(rangeValues.start, double.parse(val.toString()));
                      });
                    },
                    controller: maximo,
                    ),
                  ),
                  
                ],
              ),
            ),
          ],
          () {
              widget.profissional.limite = [rangeValues.start.toInt(), rangeValues.end.toInt()];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroDescricao(
                          profissional: widget.profissional,
                        ),
                      ));
                }
        );
      }
    );
  }
}
