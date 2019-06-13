import 'dart:convert';

import 'package:game_server/src/game/player/player_variable.dart';
import 'package:game_server/src/game/position.dart';

abstract class PositionBuilder{

    Position getPosition();

    Position build(String string){

        var jsonObject = jsonDecode(string);

        Position position = getPosition();

        position.playerIds = jsonObject['player_ids'].split(',');
        position.playerStatus = PlayerVariable.playerVariablefromString(position, jsonObject['player_status']);
        position.timeLeft = PlayerVariable.playerVariablefromString(position, jsonObject['time_left']);
        position.score = PlayerVariable.playerVariablefromString(position, jsonObject['score']);
        position.color = PlayerVariable.playerVariablefromString(position, jsonObject['color']);

        specifics(position, jsonObject['position']);

        return position;
    }

    specifics(Position position, String string);


}