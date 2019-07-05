part of message;

class PlayerList extends Message{
  static const type = 'player_list';

  String delimter = ',';
  List<String> players;

  PlayerList(this.players);

  PlayerList.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    players = jsonObject['players'].split(delimter);

  }

  get json => jsonEncode({
    'type': type,
    'players' : players.join(delimter)
  });





}