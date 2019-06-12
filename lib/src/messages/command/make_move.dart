




import 'dart:convert';

import '../message.dart';
import 'command.dart';

class MakeMove extends Message{
  static const type = 'make_move';
static const code = 'mov';

  String gameId;
  String move;
  String playerId;
  String token;

  MakeMove(this.gameId, this.playerId, this.token, this.move);

  String toString() => code
      + gameId + Command.delimiter
      + playerId + Command.delimiter
      + token + Command.delimiter
      + move.toString() + Command.delimiter;



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