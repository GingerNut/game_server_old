part of message;

class ChangeScreen extends GameMessage{
  static const type = 'change_screen';

  ChangeScreen(String screen) : super(screen);

  ChangeScreen.fromJSON(String string) : super(null){
    var jsonObject = jsonDecode(string);
    message = jsonObject['screen'];
  }

  get json => jsonEncode({
    'type': type,
    'screen' : message
  });


}