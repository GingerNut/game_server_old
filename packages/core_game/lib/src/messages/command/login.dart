part of message;

class Login extends Message{
  static const type ='login';

  String playerId;
  String password;

  Login(this.playerId, this.password);

  Login.fromJSON(String string){

    var jsonObject = jsonDecode(string);

    playerId = jsonObject['player_id'];
    password = jsonObject['password'];

  }

  get json => jsonEncode({
    'type': type,
    'player_id' : playerId,
    'password' : password
  });

}