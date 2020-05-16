import 'package:idomuss/helpers/Textos.dart';

class SliderModel{

  String _imagem;
  String _titulo;
  String _descricao;

  SliderModel(this._titulo,this._descricao,this._imagem,);

  get imagem => _imagem;

  get titulo => _titulo;

  get descricao => _descricao;

}

List<SliderModel> getSlides(){
  
  List<SliderModel> slides = new List<SliderModel>();

  slides.add(SliderModel(OnBoardingStrings.stepOneTitle,OnBoardingStrings.stepOneContent,"assets/onboarding/step-one.png"));
  slides.add(SliderModel(OnBoardingStrings.stepTwoTitle,OnBoardingStrings.stepTwoContent,"assets/onboarding/step-two.png"));
  slides.add(SliderModel(OnBoardingStrings.stepThreeTitle,OnBoardingStrings.stepThreeContent,"assets/onboarding/step-three.png"));
  
  return slides;
}