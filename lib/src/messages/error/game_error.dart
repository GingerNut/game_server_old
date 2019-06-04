import '../message.dart';

class GameError extends Message{
  static const String code = 'err';
  String text;

  GameError(this.text);


  String get string => code + delimiter + text;

  GameError.fromString(String string){
    this.text = string;
  }

}