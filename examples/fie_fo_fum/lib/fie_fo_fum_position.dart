import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/game/player_variable.dart';
import 'package:game_server/src/game/position.dart';

class FieFoFumPosition extends Position{
  FieFoFumPosition(Game game) : super(game);

  int count = 1;
  get playerOrder => PlayerOrder.countUp;
  PlayerVariable<double> score;
  PlayerVariable<double> gameTime;
  PlayerVariable<double> moveTime;

  analyse() {
    score[player] ++;
  }


  checkWin() {

  }


  setUpNewPosition() {
    count ++;
  }


  setupFirstPosition() {
    player = players[0];

  }



}