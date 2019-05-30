import 'package:game_server/src/game/computer/computer_player.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/game/settings.dart';
import 'package:game_server/src/interface/interface.dart';
import 'package:game_server/src/messages/command/new_game.dart';

abstract class LocalInterface extends Interface implements GameHost{

//TODO local games server. Only one login allowed but that stays in background

//pass and play

Settings localSettings;
Game game;
PlayerList players = new PlayerList();


addLocalPlayer(Player player) async{

  if(players.isEmpty) players.add(Player());

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


removeLocalPlayer(Player player) => players.remove(player);

startLocalGame(){

  NewGame newGame = NewGame()
    ..id= 'local game'
    ..numberOfPlayers = players.length
    ..gameTime = localSettings.gameTime
    ..moveTime = localSettings.moveTime
    ..timer = localSettings.timer
    ..playerHelp = false;

  game = getGame(this, newGame);

  game.initialise();
}



}