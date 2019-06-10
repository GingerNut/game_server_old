import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/game/position.dart';

import '../message.dart';

class SetStatus extends Message{
  static const String code = 'set';

  PlayerStatus status;

  SetStatus(PlayerStatus status){
    this.status = status;
  }

  String get string => code + Position.playerStatusToString(status);

  SetStatus.fromString(String details){
    status = Position.playerStatusFromString(details);
  }


}

