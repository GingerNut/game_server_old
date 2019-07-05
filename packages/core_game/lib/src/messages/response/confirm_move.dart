part of message;

class ConfirmMove extends Message{
  static const type = 'confirm_move';

  int number;
  String gameId;
  String playerId;

  ConfirmMove(this.number, this.gameId, this.playerId);

  ConfirmMove.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    number = jsonObject['number'];
    gameId = jsonObject['game_id'];
    playerId = jsonObject['player_id'];
  }

  get json => jsonEncode({
    'type': type,
    'number' : number,
    'game_id' : gameId,
    'player_id': playerId
  });





}