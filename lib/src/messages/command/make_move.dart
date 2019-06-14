




import 'dart:convert';

import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/move_builder.dart';

import '../message.dart';

class MakeMove extends Message{
  static const type = 'make_move';

  String gameId;
  String moveString;
  String playerId;

  MakeMove(this.gameId, this.playerId, Move move){
    moveString = move.string;
  }

  MakeMove.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    gameId = jsonObject['game_id'];
    moveString = jsonObject['move'];
    playerId = jsonObject['player_id'];
  }

  get json => jsonEncode({
    'type': type,
    'move' : moveString,
    'player_id': playerId,
  });

  Move build(MoveBuilder builder) => builder.build(moveString);

}