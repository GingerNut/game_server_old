import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/game/position.dart';

class TestPosition extends Position{
  TestPosition(Game game) : super(game);

  int count = 0;
  get playerOrder => PlayerOrder.countUp;

  analyse() {

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