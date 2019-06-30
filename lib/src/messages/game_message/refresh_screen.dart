part of game_message;

class RefreshScreen extends GameMessage{
  static const type = 'update_screen';

  RefreshScreen();

  RefreshScreen.fromJSON(String string){
    var jsonObject = jsonDecode(string);

  }

  get json => jsonEncode({
    'type': type,
  });





}