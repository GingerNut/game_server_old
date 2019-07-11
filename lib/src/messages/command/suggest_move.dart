part of message;

class SuggestMove extends Message{
  static const String type = 'suggest_move';

  String gameId;
  String moveString;
  String playerId;
  int number;

  SuggestMove(this.gameId, this.playerId, Move move, this. number){
    moveString = move.string;
  }

  SuggestMove.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    gameId = jsonObject['game_id'];
    moveString = jsonObject['move'];
    playerId = jsonObject['player_id'];
    number = jsonObject['number'];
  }

  get json => jsonEncode({
    'type': type,
    'move' : moveString,
    'player_id': playerId,
    'number': number
  });

  Move build(MoveBuilder builder) => builder.build(moveString);

}