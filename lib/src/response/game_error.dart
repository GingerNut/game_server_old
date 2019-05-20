




import 'package:game_server/src/response/response.dart';

class GameError extends Response{

  String error = '';

  bool operator ==(other) => other is GameError && error == other.error;

  String string;

  GameError.alreadyInGame(String playerId, String gameId);

  GameError.badMove(String playerId);

  GameError.playerOutOfTime(String playerId);

  GameError. gameNotFound();

  GameError.playerNotFound();

  GameError.alreadyLoggedIn(String id);

  GameError.badCommand(this.error);

}