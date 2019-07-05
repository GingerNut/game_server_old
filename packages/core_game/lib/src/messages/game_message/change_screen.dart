part of game_message;

class ChangeScreen extends GameMessage{
  static const type = 'change_screen';

  String screen;

  ChangeScreen(this.screen);

  ChangeScreen.fromJSON(String string){
    var jsonObject = jsonDecode(string);
    screen = jsonObject['screen'];
  }

  get json => jsonEncode({
    'type': type,
    'screen' : screen
  });


}