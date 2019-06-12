import 'dart:convert';

import '../message.dart';

class Logout extends Message{
  static const type = 'logout';
  static const code = 'lgo';
  String player_id;

  Logout(this.player_id);

  String get string => code;

  Logout.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    player_id = jsonObject['player_id'];
  }

  get json => jsonEncode({
    'type': type,
    'player_id' : player_id
  });





}