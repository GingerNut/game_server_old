



import 'command.dart';

class JoinGame{

  final String gameId;
  final String playerId;
  final String playerToken;

  JoinGame(this.gameId, this.playerId, this.playerToken);




  @override
  String toString() => Command.joinGame
      + gameId + Command.delimiter
      + playerId + Command.delimiter
      + playerToken;
}