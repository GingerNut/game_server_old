import 'dart:convert';

import 'package:game_server/src/game/player/player_variable.dart';
import 'package:game_server/src/game/position.dart';

import '../game_dependency.dart';

class PositionBuilder{

    final GameDependency dependencies;

    PositionBuilder(this.dependencies);

    Position build(String string){

        var jsonObject = jsonDecode(string);

        Position position = dependencies.getPosition();
        position.gameId = jsonObject['game_id'];
        position.playerIds = jsonObject['player_ids'].split(',');
        position.playerQueue = jsonObject['player_queue'].split(',');
        position.playerStatus = PlayerVariable.playerVariablefromString(jsonObject['player_status']);
//        position.timeLeft = PlayerVariable.playerVariablefromString( jsonObject['time_left']);
        position.score = PlayerVariable.playerVariablefromString(jsonObject['score']);
        position.color = PlayerVariable.playerVariablefromString(jsonObject['color']);

        position.setExternalVariables(jsonObject['position']);

        return position;
    }


}