
import 'dart:convert';

import 'package:game_server/src/design/palette.dart';
import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/game/player/player_variable.dart';
import 'package:game_server/src/game/position_builder.dart';
import 'package:game_server/src/messages/command/new_game.dart';
import 'package:game_server/src/messages/command/send_position.dart';

import 'move.dart';

abstract class Position{

  Move lastMove;

  String gameId;
  List<String> playerIds;
  List<String> playerQueue;

  PositionBuilder get positionBuilder;

  PlayerVariable<PlayerStatus> playerStatus;
  PlayerVariable<double> score;
  PlayerVariable<double> timeLeft;
  PlayerVariable<int> color;

  String get string;

  String get json => jsonEncode({
    'game_id' : gameId,
    'player_ids' : playerIds.join(','),
    'player_queue' : playerQueue.join(','),
    'player_status' : playerStatus.string,
    'time_left': timeLeft.string,
    'score' : score.string,
    'color': color.string,
    'position' : string,
  }
  );

  Position get duplicate => SendPosition.fromPosition(this).build(positionBuilder);

  String get playerId => playerQueue[0];

  PlayerOrder get playerOrder;

  String winner;
  bool gameOver = false;

  bool canPlay(String id);

  makeMove(Move move){
    move.go(this);
    lastMove = move;

    analyse();
    checkWin();

    setNextPlayer();

    if(playerQueue.length < 2 && playerIds.length > 1){
      gameOver = true;

      if(playerQueue.length == 1) winner = playerQueue[0];

    }

    if (!gameOver) {

      setUpNewPosition();
    }
  }

  playerOut() => playerStatus[playerId] = PlayerStatus.out;

  setNextPlayer(){

    switch(playerOrder){
      case PlayerOrder.sequential:
        String p = playerQueue.removeAt(0);
        if(playerStatus[p] == PlayerStatus.playing) playerQueue.add(p);
        break;

      case PlayerOrder.random:
        String p = playerQueue[0];
        if(playerStatus[p] != PlayerStatus.playing) playerQueue.remove(p);
        playerQueue.shuffle();
        break;

      case PlayerOrder.firstToPlay:
      // TODO: Handle this case.
        break;

      case PlayerOrder.highestScore:
      // TODO: Handle this case.
        break;

      case PlayerOrder.lowestScore:
      // TODO: Handle this case.
        break;
    }

  }

  initialise(NewGame settings){
    playerStatus = PlayerVariable(this, PlayerStatus.ingameNotReady);
    score = PlayerVariable(this, 0);
    timeLeft = PlayerVariable(this, settings.gameTime);
    color = PlayerVariable.fromList(this, Palette.defaultPlayerColours);
  }

  setFirstPlayer();

  setupFirstPosition();

  setUpNewPosition();

  analyse();

  checkWin();

  static String playerStatusToString(PlayerStatus p){

    switch (p){
      case PlayerStatus.winner:
        return 'winner';

      case PlayerStatus.disconnected:
        return'disconnected';

      case PlayerStatus.out:
        return 'out';

      case PlayerStatus.ingameNotReady:
        return 'waiting';

      case PlayerStatus.ready:
        return 'ready';

      case PlayerStatus.playing:
        return 'playing';

      case PlayerStatus.queuing:
        return'queuing';
        break;
    }

  }

  static PlayerStatus playerStatusFromString(String string){
    switch (string){
      case 'winner':
        return PlayerStatus.winner;
        break;

      case 'disconnected':
        return PlayerStatus.disconnected;
        break;

      case 'out':
        return PlayerStatus.out;
        break;

      case 'waiting':
        return PlayerStatus.ingameNotReady;
        break;

      case 'ready':
        return PlayerStatus.ready;
        break;

      case 'playing':
        return PlayerStatus.playing;
        break;

      case 'queuing':
        return PlayerStatus.queuing;
        break;
    }

  }

}


enum PlayerOrder{
  sequential,
  random,
  firstToPlay,
  highestScore,
  lowestScore
}


