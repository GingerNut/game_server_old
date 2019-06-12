



import 'dart:convert';

import '../message.dart';

class Login extends Message{
  static const type ='login';

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

  Login.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    playerId = jsonObject['player_id'];
  }

  get json => jsonEncode({
    'type': type,
    'player_id' : playerId,
    'password' : password
  });

}