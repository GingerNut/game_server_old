import 'dart:convert';

import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/game/position.dart';

import '../message.dart';

class SetStatus extends Message{
  static const type = 'set_player_status';
  static const String code = 'set';

  PlayerStatus status;

  SetStatus(PlayerStatus status){
    this.status = status;
  }

  String get string => code + Position.playerStatusToString(status);

  SetStatus.fromString(String details){
    status = Position.playerStatusFromString(details);
  }



  SetStatus.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    status = Position.playerStatusFromString(jsonObject['status']);
  }

  get json => jsonEncode({
    'type': type,

    'status' : Position.playerStatusToString(status)
  });

}

