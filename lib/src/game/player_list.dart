


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

  Player getPlayer(Position position){

   Player next;
    switch(position.playerOrder){
      case PlayerOrder.countUp:
        next = _players[(position.player.number + 1) % _players.length];
        while(next.playerStatus != PlayerStatus.playing){
          next = _players[(next.number + 1) % _players.length];
        }
        break;
      case PlayerOrder.countDown:
        next = _players[(position.player.number - 1) % _players.length];
        while(next.playerStatus != PlayerStatus.playing){
          next = _players[(next.number - 1) % _players.length];
        }
        break;
      case PlayerOrder.random:
      // TODO: Handle this case.
        break;
      case PlayerOrder.firstToPlay:
      // TODO: Handle this case.
        break;
      case PlayerOrder.highestScore:
      // TODO: Handle this case.
        break;
      case PlayerOrder.lowersScore:
      // TODO: Handle this case.
        break;
    }
    return next;

  }

  PlayerList remainingPlayers(Position position){
      PlayerList remain = PlayerList();

      _players.forEach((p) => p.playerStatus == PlayerStatus.playing ? remain.add(p) :  false);

      return remain;
  }

  int playersLeft(Position position){

    int remain = 0;;

    _players.forEach((p) => p.playerStatus== PlayerStatus.playing ? remain ++ :  false);

    return remain;

  }



}

enum PlayerOrder{
  countUp,
  countDown,
  random,
  firstToPlay,
  highestScore,
  lowersScore
}