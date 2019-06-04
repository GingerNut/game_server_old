

import 'package:game_server/src/game/computer/computer_player.dart';
import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/game/settings.dart';
import 'package:game_server/src/messages/response/game_error.dart';
import 'package:game_server/src/messages/response/response.dart';
import 'package:game_server/src/messages/response/success.dart';

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

  Future<Response> requestJoin(Player player) async{

    if(player == null) return GameError.playerNotFound();

    if(players.contains(player.id)) return GameError.alreadyInGame(player.id, id);

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

  NewGame.local(Settings settings){
    id = 'local game';
    gameTime = settings.gameTime;
    moveTime = settings.moveTime;
    timer = settings.timer;
    playerHelp = false;
  }

  addLocalPlayer(Player player) async{

    if(players.length < Settings.maxPlayers) players.add(player);

    players.forEach((p){
      if(p.displayName == null){

        String base;

        if(p is ComputerPlayer) base = 'Computer';
        else base = 'Player';

        int trialInt = 1;

        String trialName = base + ' ' + trialInt.toString();

        while(players.containsPlayerWithDisplayName(trialName)){
          trialInt ++;
          trialName = base + ' ' + trialInt.toString();

        }
        p.displayName = trialName;
      }


    });

  }




}