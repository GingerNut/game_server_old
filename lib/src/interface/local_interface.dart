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
NewGame newGame;


resetGame(){
  newGame = NewGame.local(localSettings);

}

addPlayer(Player player) => newGame.addLocalPlayer(player);



}