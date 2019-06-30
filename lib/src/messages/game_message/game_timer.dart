part of game_message;


class GameTimer extends GameMessage{
  static const String type = 'start_timer';

  String instruction;
  String playerId;
  double timeLeft;

  GameTimer(this.playerId, this.timeLeft, this.instruction);

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