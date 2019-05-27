

import 'package:game_server/src/messages/response/game_error.dart';
import 'package:game_server/src/messages/response/response.dart';
import 'package:game_server/src/messages/response/success.dart';

import 'command.dart';

class NewGame extends Command{
  String id;
  String displayName ='';
  List<String> playerIds = new List();
  int numberOfPlayers;
  int playerType;
  bool playerHelp;
  bool timer;
  double moveTime;
  double gameTime;

  bool get full => playerIds.length == numberOfPlayers;
  NewGame();

  addPlayerFromPlayerList(String id){
    if(full) return;

   playerIds.add(id);
  }

  Future<Response> requestJoin(String playerId) async{

    if(playerId == null) return GameError.playerNotFound();

    if(playerIds.contains(playerId)) return GameError.alreadyInGame(playerId, id);

    playerIds.add(playerId);

    return Success();
  }


  NewGame.fromString(String details){

    List<String> detailList = details.split('\n');

    this.displayName = detailList[0];
    this.numberOfPlayers = int.parse(detailList[1]);
    this.timer = detailList[2] == 'TRUE' ? true : false;
    this.moveTime = double.parse(detailList[3]);
    this.gameTime = double.parse(detailList[4]);
  }

  String toString() {

    String string = '';
    string += displayName;
    string += Command.delimiter;
    string += numberOfPlayers.toString();
    string += Command.delimiter;
    string += timer ? 'TRUE' : 'FALSE';
    string += Command.delimiter;
    string += moveTime.toString();
    string += Command.delimiter;
    string += gameTime.toString();
    string += Command.delimiter;

    return string;
  }






}