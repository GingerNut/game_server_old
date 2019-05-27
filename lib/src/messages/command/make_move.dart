




import 'command.dart';

class MakeMove extends Command{
  final String gameId;
  final String move;
  final String playerId;
  final String token;

  MakeMove(this.gameId, this.playerId, this.token, this.move);

  String toString() => Command.move
      + gameId + Command.delimiter
      + playerId + Command.delimiter
      + token + Command.delimiter
      + move.toString() + Command.delimiter;

}