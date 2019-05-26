


import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/response/response.dart';
import 'package:game_server/src/response/success.dart';

import 'command.dart';

class NewGame extends Command{
  String id;
  String displayName ='';
  PlayerList players = new PlayerList();
  int numberOfPlayers;
  int playerType;
  bool playerHelp;
  bool timer;
  double moveTime;
  double gameTime;

  bool get full => players.length == numberOfPlayers;
  NewGame();

  addPlayerFromPlayerList(PlayerList players, String id){
    if(full) return;

    players.add(players.getPlayerWithId(id));
  }

  Future<Response> requestJoin(String playerId, String token) async{

    if(player == null) return GameError.playerNotFound();

    if(player.secret != token) return GameError.playerNotFound();

    if(players.contains(playerId)) return GameError.alreadyInGame(playerId, id);

    players.add(player);

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