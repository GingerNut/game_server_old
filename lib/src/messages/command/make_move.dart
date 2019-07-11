part of message;

class MakeMove extends Message{
  static const type = 'make_move';

  String gameId;
  String moveString;
  String playerId;
  int number;

  MakeMove(this.gameId, this.playerId, Move move, this. number){
    moveString = move.string;
  }

  MakeMove.fromJSON(String string){
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

  Move getMove(GameDependency dependency){

    return dependency.getMoveBuilder().build(moveString);
  }


}