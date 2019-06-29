part of message;

class GameMessage extends Message {
  static const type = 'game_message';

  String message;

  GameMessage(this.message);

  GameMessage.fromJSON(String string){
    var jsonObject = jsonDecode(string);
    message = jsonObject['message'];
  }

  get json =>
      jsonEncode({
        'type': type,
        'message': message,
      });

  static inflate(String string) {
    var jsonObject = jsonDecode(string);

    switch (jsonObject['type']) {
      case GameMessage.type:
        return GameMessage.fromJSON(string);
      case RefreshScreen.type:
        return RefreshScreen.fromJSON(string);
      case ChangeScreen.type:
        return ChangeScreen.fromJSON(string);
      default:
        return null;
    }
  }

}