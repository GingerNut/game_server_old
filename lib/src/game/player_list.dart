


import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/position.dart';

class PlayerList{

  List<Player> _players;

  PlayerList([int size]){

    if(size != null) _players = List(size);
    else _players = List();

  }

  operator [](int i) => _players[i];
  operator []=(int i, Player value) => _players[i] = value;

  add(Player player) {
    //if(containsPlayerId(player.id)) return;
    _players.add(player);
  }
  remove(Player player) =>  _players.remove(player);
  bool get isEmpty => _players.isEmpty;
  int get length  => _players.length;

  bool contains(String id) {
    Player player = getPlayerWithId(id);
    if(player == null) return false;
    else return true;
  }

  clear() => _players.clear();
  forEach(Function(Player player) function) => _players.forEach(function);

  Player get winner{
    Player winner;

    if(playersLeft != 1) return null;

    _players.forEach((p) {
      if(p.status == PlayerStatus.playing) winner = p;

    });
    return winner;
  }

  Player getPlayerWithId(String id){

    Player player;

    _players.forEach((p) {
      if(p.id == id) player = p;
    });

    return player;

  }

  containsPlayerWithDisplayName(String string){

    bool containsPlayer = false;

    _players.forEach((p) {
      if(p.displayName == string) containsPlayer = true;
    });

    return containsPlayer;

  }

  containsPlayerId(String string){

    bool containsPlayer = false;

    _players.forEach((p) {
      if(p.id == string) containsPlayer = true;
    });

    return containsPlayer;

  }

  printAll(){
    _players.forEach((p) => print(p.id));

  }

  List<String> listAllNames(){

    List<String> names = new List();

    _players.forEach((p) => names.add(p.displayName));

    return names;

  }

  Future<String> getListOfUsers() async{
    String response = '';

    _players.forEach((p) {
      response += p.id;
      response += '\n';

    } );

    return response;
  }

  Player get first => _players.first;
  Player get last => _players.last;


  PlayerList get remainingPlayers{
      PlayerList remain = PlayerList();

      _players.forEach((p) => p.status == PlayerStatus.playing ? remain.add(p) :  false);

      return remain;
  }

  int get playersLeft{

    int remain = 0;;

    _players.forEach((p) => p.status== PlayerStatus.playing ? remain ++ :  false);

    return remain;

  }



}

enum PlayerOrder{
  sequential,
  random,
  firstToPlay,
  highestScore,
  lowestScore
}