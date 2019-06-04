





import '../message.dart';

class Success extends Message{
  static const String code = 'suc';
  String text;

  bool operator ==(other) => other is Success;


  Success.login(String playerId){

    text = 'Successful login for player ' + playerId;
  }

  Success();

  Success.fromString(String string){
    this.text = string;
  }


  String get string => code + text != null ? delimiter + text : '';



}