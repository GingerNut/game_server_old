

import 'package:game_server/src/game/palette.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game_server/member.dart';
import 'package:game_server/src/messages/response/response.dart';
import 'package:game_server/src/messages/response/success.dart';

import 'game.dart';
import 'game_timer.dart';

class Player{
  static const int human = 0;
  static const int computer = 1;
  static const int internet = 2;

  Game game;
  Member member;
  String id;
  String displayName;
  String gameId;

  int number;
  int color;
  String reasonOut;
  double score;
  PlayerStatus playerStatus = PlayerStatus.waiting;

  GameTimer timer;

  double get timeLeft => timer.timeLeft;

  initialise(){
    color = Palette.defaultPlayerColours[number];
    timer = GameTimer(this, game.settings.gameTime, moveTime: game.settings.moveTime);

    if(game.id == 'local game') playerStatus = PlayerStatus.ready;

  }


  yourTurn(Position position){
    
  }

  sendMessage(String string){}

  wait(){

  }

  outOfTime(){
    Position position = game.position;

    playerStatus = PlayerStatus.out;
    position.checkWin();
  }


}


enum PlayerStatus{
  winner,
  disconnected,
  out,
  waiting,
  ready,
  playing
}