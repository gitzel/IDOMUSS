import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';

class LoadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitDoubleBounce(
          color: ColorSys.primary,
          size: 50.0,
        ),
      ),
    );
  }
}