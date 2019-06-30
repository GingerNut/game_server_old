part of game_message;


class GameTimer extends GameMessage{
  static const String type = 'start_timer';

  String instruction;
  String playerId;
  double timeLeft;

  GameTimer.start(Position position){
    playerId = position.playerId;
    timeLeft = position.timeLeft[playerId];
    instruction = 'start';
  }

  GameTimer.stop(Position position){
    playerId = position.playerId;
    timeLeft = position.timeLeft[playerId];
    instruction = 'stop';
  }

  GameTimer.tick(Position position){
    playerId = position.playerId;
    timeLeft = position.timeLeft[playerId];
    instruction = 'tick';
  }

  GameTimer.fromJSON(String string){
    var jsonObject = jsonDecode(string);
    instruction = jsonObject['instruction'];
    playerId = jsonObject['player_id'];
    timeLeft = jsonObject['time_left'];
  }

  get json =>
      jsonEncode({
        'type': type,
        'instruction': instruction,
        'player_id' : playerId,
        'time_left' : timeLeft
      });

}