part of message;

class JoinGame extends Message{
  static const type = 'join_game';

    String gameId;


  JoinGame(NewGame game){
    this.gameId = game.id;
  }


  JoinGame.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    gameId = jsonObject['game_id'];
  }

  get json => jsonEncode({
    'type': type,
    'game_id' : gameId
  });
}