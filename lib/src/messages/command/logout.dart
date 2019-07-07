part of message;

class Logout extends Message{
  static const type = 'logout';

  String player_id;

  Logout(this.player_id);

  Logout.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    player_id = jsonObject['player_id'];
  }

  get json => jsonEncode({
    'type': type,
    'player_id' : player_id
  });





}