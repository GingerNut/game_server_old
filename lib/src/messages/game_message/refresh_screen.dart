part of message;

class RefreshScreen extends Message{
  static const type = 'update_screen';

  RefreshScreen();

  RefreshScreen.fromJSON(String string){
    var jsonObject = jsonDecode(string);

  }

  get json => jsonEncode({
    'type': type,
  });





}