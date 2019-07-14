part of message;

class YourTurn extends Message{
  static const String type = 'your_turn';

  String gameId;
  int aiDepth;
  double thinkingTime;

  YourTurn(this.gameId, this.aiDepth, this.thinkingTime);


  YourTurn.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    gameId = jsonObject['game_id'];
    aiDepth = jsonObject['ai_depth'];
    thinkingTime = jsonObject['thinking_time'];

  }

  get json => jsonEncode({
    'type': type,
    'game_id' : gameId,
    'ai_depth' : aiDepth,
    'thinking_time' : thinkingTime,

  });
}