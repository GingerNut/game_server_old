




import 'dart:convert';

import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/move_builder.dart';

import '../message.dart';
import 'make_move.dart';

class SuggestMove extends MakeMove{
  static const type = 'suggest_move';

  SuggestMove(String gameId, String playerId, Move move) : super(gameId, playerId, move);

  SuggestMove.fromJSON(String string) : super.fromJSON(string);

  get makeMove => MakeMove.fromJSON(json);

  get json => jsonEncode({
    'type': type,
    'move' : moveString,
    'player_id': playerId,
  });

}