



import 'dart:convert';

import '../message.dart';

class Login extends Message{
  static const type ='login';

  String playerId;
  String password;

  Login(this.playerId, this.password);

  Login.fromString(String string){
    List<String> details = string.split((delimiter));

    playerId = details[0];
    password = details[1];
  }


  Login.fromJSON(String string){

    var jsonObject = jsonDecode(string);

    playerId = jsonObject['player_id'];
    password = jsonObject['password'];

  }

  get json => jsonEncode({
    'type': type,
    'player_id' : playerId,
    'password' : password
  });

}