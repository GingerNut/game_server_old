part of chess;

class ChessInjector extends GameDependency{

  Uri get computerUri => Uri.parse('package:chess/chess_isolate.dart');
  
  Game getGame(NewGame newGame) => Game.fromNewGame(this, newGame);

  MoveBuilder getMoveBuilder() => ChessMoveBuilder();

  Position getPosition() => ChessPosition();

  getInput(Interface interface) => ChessInput(interface);

  setPositionType(Position position) => position as ChessPosition;

  Settings get settings => ChessSettings();

}