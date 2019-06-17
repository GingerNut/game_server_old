
import 'package:game_server/src/game/game.dart';

import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game/settings.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import '../game_dependency.dart';
import 'interface.dart';


class LocalInterface extends Interface{

//TODO local games server. Only one login allowed but that stays in background

//pass and play

Settings localSettings = Settings();
Game game;
NewGame newGame;

getGame(NewGame newGame) => dependency.getGame(newGame);



Position get position => game.position;

LocalInterface(GameDependency injector) : super(injector){
  resetGame();
}

resetGame(){
  newGame = NewGame.local(dependency.settings);
}

addPlayer(Player player) => newGame.addLocalPlayer(player);

startGame(NewGame newgame)async{
  game = getGame(newgame);
  await game.initialise();
}

makeMove(Move move) => game.makeMove(move, game.gameId, game.position.playerId);





}