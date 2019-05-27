




import 'command.dart';

class StartGame {

  final String gameId;
  final String playerId;
  final String playerToken;

  StartGame(this.gameId, this.playerId, this.playerToken);

  @override
  String toString() =>
      Command.startGame
          + gameId + Command.delimiter
          + playerId + Command.delimiter
          + playerToken;


}