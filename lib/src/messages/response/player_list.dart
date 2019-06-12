import 'dart:convert';

import '../message.dart';

class PlayerList extends Message{
  static const type = 'player_list';
  static const code = 'pll';
  String delimter = ',';
  List<String> players;

  PlayerList(this.players);

  String get string => code;

  PlayerList.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    players = jsonObject['players'].split(delimter);

  }

  get json => jsonEncode({
    'type': type,
    'players' : players.join(delimter)
  });





}