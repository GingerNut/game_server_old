

import 'package:game_server/src/game/position.dart';

class FieFoFumPosition extends Position{

  int count = 1;
  get playerOrder => PlayerOrder.sequential;
  PlayerVariable<double> score;
  PlayerVariable<double> gameTime;
  PlayerVariable<double> moveTime;

  analyse() {
    score[playerId] ++;
  }


  checkWin() {

  }


  setUpNewPosition() {
    count ++;
  }

  setFirstPlayer(){
   playerQueue.shuffle();
  }


  setupFirstPosition() {


  }


  findBestMove() {

  }



}