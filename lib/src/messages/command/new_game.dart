

import 'package:game_server/src/game/computer/computer_player.dart';
import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/game/settings.dart';
import 'package:game_server/src/messages/error/game_error.dart';
import 'package:game_server/src/messages/response/success.dart';

import '../message.dart';

class NewGame extends Message{
  static const String code = 'new';

  String id;
  String displayName ='';
  PlayerList players = new PlayerList();
  int maxPlayers;
  int numberOfPlayers = 0;
  int playerType;
  bool playerHelp;
  bool timer;
  double moveTime;
  double gameTime;

  bool get full => players.length == maxPlayers;

  int get hash => maxPlayers + numberOfPlayers;

  NewGame();

  NewGame.fromSettings(Settings settings){
    this.displayName = settings.onlineGameName;
    this.maxPlayers = settings.numberOfPlayers;
    this.gameTime = settings.gameTime;
    this.moveTime = settings.moveTime;
    this.timer = settings.timer;
    this.playerHelp = settings.playerHelp;
  }

  Future<Message> requestJoin(Player player) async{

    if(player == null) return GameError('player not found');

    if(players.contains(player.id)) return GameError('already in game');

    players.add(player);

    return Success();
  }


  NewGame.fromString(String details){

    List<String> detailList = details.split(delimiter);

    this.displayName = detailList[0];
    this.maxPlayers = int.parse(detailList[1]);
    this.numberOfPlayers = int.parse(detailList[2]);
    this.timer = detailList[3] == 'TRUE' ? true : false;
    this.moveTime = double.parse(detailList[4]);
    this.gameTime = double.parse(detailList[5]);
  }

  String get string{
    String string = '';
    string += code;
    string += displayName + delimiter;
    string += maxPlayers.toString() + delimiter;
    string += numberOfPlayers.toString() + delimiter;
    string += timer ? 'TRUE' : 'FALSE' ;
    string += delimiter;
    string += moveTime.toString() + delimiter;
    string += gameTime.toString() + delimiter;
    return string;
  }

  NewGame.local(Settings settings){
    id = 'local game';
    maxPlayers = Settings.maxPlayers;
    gameTime = settings.gameTime;
    moveTime = settings.moveTime;
    timer = settings.timer;
    playerHelp = false;
  }

  addLocalPlayer(Player player){

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
        p.id = trialName;
      }

    });

  }


}