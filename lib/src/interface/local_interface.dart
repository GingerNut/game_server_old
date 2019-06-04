import 'package:game_server/src/game/computer/computer_player.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game/settings.dart';
import 'package:game_server/src/messages/command/new_game.dart';


abstract class LocalInterface implements GameHost{

//TODO local games server. Only one login allowed but that stays in background

//pass and play

Settings localSettings = Settings();
Game game;
NewGame newGame;

Position get position => game.position;

LocalInterface(){
  resetGame();
}

resetGame(){
  newGame = NewGame.local(localSettings);
}

addPlayer(Player player) => newGame.addLocalPlayer(player);

startGame(NewGame newgame)async{
  game = getGame(newgame);
  await game.initialise();
}

makeMove(Move move) => game.makeMove(move);

}