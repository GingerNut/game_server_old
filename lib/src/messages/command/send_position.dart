import 'dart:convert';

import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game/position_builder.dart';

import '../message.dart';

class SendPosition extends Message{
  static const type = 'send_game';

  Position position;
  String positionString;

  SendPosition();

  SendPosition.fromGame(Game game){

    position = game.position;
    positionString = position.json;
  }

  SendPosition.fromPosition(Position position){

    this.position = position;
    positionString = position.json;
  }

  SendPosition.fromJSON(String string){

    var jsonObject = jsonDecode(string);

    String p = jsonObject['position_string'];

    positionString = p;


  }

  get json {

    return jsonEncode({
    'type': type,
    'position_string' : positionString,

  });
  }

  Position build(PositionBuilder builder) => builder.build(positionString);

}