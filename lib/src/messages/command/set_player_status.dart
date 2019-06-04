import 'package:game_server/src/game/player.dart';

import '../message.dart';

class SetStatus extends Message{
  static const String code = 'set';

  PlayerStatus status;

  SetStatus(PlayerStatus status){
    this.status = status;
  }

  String get string => code + statusString;

  SetStatus.fromString(String details){
    setStatus(details);
  }

  String get statusString {

    switch (status){
      case PlayerStatus.winner:
       return 'winner';

      case PlayerStatus.disconnected:
       return'disconnected';

      case PlayerStatus.out:
        return 'out';

      case PlayerStatus.waiting:
        return 'waiting';

      case PlayerStatus.ready:
        return 'ready';

      case PlayerStatus.playing:
        return 'playing';
    }

  }

  setStatus(String details){

    switch (details){
      case 'winner':
      status = PlayerStatus.winner;
      break;

      case 'disconnected':
        status = PlayerStatus.disconnected;
        break;

      case 'out':
        status = PlayerStatus.out;
        break;

      case 'waiting':
        status = PlayerStatus.waiting;
        break;

      case 'ready':
        status = PlayerStatus.ready;
        break;

      case 'playing':
        status = PlayerStatus.playing;
        break;
    }


  }


}




//enum PlayerStatus{
//  winner,
//  disconnected,
//  out,
//  waiting,
//  ready,
//  playing
//}