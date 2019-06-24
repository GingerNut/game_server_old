part of chess;

class ChessInjector extends GameDependency{

  Uri get computerUri => Uri.dataFromString('package:game_server/examples/chess/lib/chess_isolate.dart');
  
  Game getGame(NewGame newGame) => Game.fromNewGame(this, newGame);

  MoveBuilder getMoveBuilder() => ChessMoveBuilder();

  Position getPosition() => ChessPosition();

  getInput() => ChessInput();

  setPositionType(Position position) => position as ChessPosition;

  Settings get settings => ChessSettings();

  Notation get notation => ChessNotation();




}