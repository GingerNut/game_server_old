



import '../message.dart';

class Login extends Message{

  static const code = 'log';
  String playerId;
  String password;

  Login(this.playerId, this.password);

  Login.fromString(String string){
    List<String> details = string.split((delimiter));

    playerId = details[0];
    password = details[1];
  }



  String get string => code + playerId + delimiter + password;



}