




import 'dart:convert';

import '../message.dart';

class MakeMove extends Message{
  static const type = 'make_move';


  String gameId;
  String move;
  String playerId;
  String token;

  MakeMove(this.gameId, this.playerId, this.token, this.move);

  MakeMove.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    gameId = jsonObject['game_id'];
    move = jsonObject['move'];
    playerId = jsonObject['player-id'];
    token = jsonObject['token'];
  }

  get json => jsonEncode({
    'type': type,
    'move' : move,
    'player_id': playerId,
    'token': token
  });

  @override
  // TODO: implement string
  String get string => null;
}