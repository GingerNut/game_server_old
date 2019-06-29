part of message;

class RefreshScreen extends GameMessage{
  static const type = 'update_screen';

  RefreshScreen() : super(null);

  RefreshScreen.fromJSON(String string) : super(null){
    var jsonObject = jsonDecode(string);

  }

  get json => jsonEncode({
    'type': type,
  });





}