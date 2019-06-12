


import 'dart:convert';

import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/game/settings.dart';
import 'package:game_server/src/messages/error/game_error.dart';
import 'package:game_server/src/messages/response/success.dart';

import '../message.dart';

class NewGame extends Message{
  static const String type = 'new_game';

  String id = 'game id';
  String displayName ='';
  List players = new List();
  int maxPlayers;
  int numberOfPlayers = 0;
  int playerType;
  bool playerHelp;
  bool timer;
  double moveTime;
  double gameTime;

  bool get full => players.length == maxPlayers;

  int get hash => maxPlayers + numberOfPlayers;

  int get hashCode => hash;

  bool operator == (o){
    if(o.id == id) return true;
    else return false;
  }

  NewGame();

  NewGame.fromSettings(Settings settings){
    this.displayName = settings.onlineGameName;
    this.maxPlayers = settings.numberOfPlayers;
    this.gameTime = settings.gameTime;
    this.moveTime = settings.moveTime;
    this.timer = settings.timer;
    this.playerHelp = settings.playerHelp;
  }





  NewGame.local(Settings settings){
    id = 'local game';
    maxPlayers = Settings.maxPlayers;
    gameTime = settings.gameTime;
    moveTime = settings.moveTime;
    timer = settings.timer;
    playerHelp = false;
  }

  Future<Message> requestJoin(Player player) async{

    if(player == null) return GameError('player not found');

    if(players.contains(player.id)) return GameError('already in game');

    players.add(player);

    return Success();
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

        while(players.any((p)=>p.id == trialName)){
          trialInt ++;
          trialName = base + ' ' + trialInt.toString();

        }
        p.displayName = trialName;
        p.id = trialName;
      }

    });

  }


  NewGame.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    id = jsonObject['id'];
    displayName = jsonObject['display_name'];
    maxPlayers = jsonObject['max_players'];
    numberOfPlayers = jsonObject['number_of_players'];
    timer = jsonObject['time'] == 'TRUE' ? true : false;
    moveTime = jsonObject['move_time'];
    gameTime = jsonObject['game_time'];
  }

  get json => jsonEncode({
    'type': type,

    'display_name':displayName,
    'max_players': maxPlayers,
    'number_of_players':numberOfPlayers,
    'timer': timer == true ? 'TRUE' : 'FALSE',
    'move_time':moveTime,
    'game_time':gameTime
  });

}