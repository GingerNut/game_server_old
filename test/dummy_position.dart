import 'package:game_server/src/game/game.dart';

class DummyPosition extends Position{

  String playerId;

  analyse() {}

  bool canPlay(String id) => true;

  GameDependency get dependency => null;

  String get externalVariablesString => '';

  List<Move> getPossibleMoves() => [];

  initialiseExternalVariables() {}

  PlayerOrder get playerOrder => PlayerOrder.sequential;

  setExternalVariables(String string) {}

  setUpNewPosition() {}

  double valuationOfPlayer(String playerId) => 0;


}