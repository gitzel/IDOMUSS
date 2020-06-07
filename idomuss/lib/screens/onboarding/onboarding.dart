import 'package:flutter/material.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/screens/onboarding/slides.dart';
import 'package:idomuss/screens/onboarding/slidetile.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<SliderModel> paginas;
  int currentIndex = 0;

  @override
  void initState() {
    paginas = getSlides();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView.builder(
            itemCount: paginas.length,
            itemBuilder: (context, index) {
              return SlideTile(
                imagePath: paginas[index].imagem,
                titulo: paginas[index].titulo,
                descricao: paginas[index].descricao,
              );
            },
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Text("Pular"),
              ),
              Container(
                child: Row(
                  children: _buildIndicator(),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Text("Pular"),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget makePage({image, title, content}) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(image),
          ),
          SizedBox(
            height: 30,
          ),
          RichText(
              text: TextSpan(
                text: title,
                style: TextStyle(
                  color: ColorSys.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat', // tem q instalar a fonte
                ),
              ),
              textAlign: TextAlign.center),
          SizedBox(
            height: 20,
          ),
          RichText(
              text: TextSpan(
                text: content,
                style: TextStyle(
                  color: ColorSys.gray,
                  fontFamily: 'Montserrat', // tem q instalar a fonte
                ),
              ),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 30 : 8,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: ColorSys.primary, borderRadius: BorderRadius.circular(5)),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < paginas.length; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}
