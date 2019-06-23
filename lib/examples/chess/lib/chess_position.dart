part of chess;

class ChessPosition extends Position{

  ChessBoard board;

  String whitePlayer;
  String blackPlayer;



  String get string {

    String string = '';


    return string;
  }

  @override
  analyse() {

  }

  @override
  bool canPlay(String id) => (playerId == id);

  GameDependency get dependency => ChessInjector();

  String get externalVariablesString => null;

  List<Move> getPossibleMoves() {
    List<Move> moves = List();

    List<Piece> army;

    if(playerId == whitePlayer) army = board.whiteArmy;
    else army = board.blackArmy;

    army.forEach((p){

      List<Tile> tiles = p.legalMoves;

      tiles.forEach((t) => moves.add(ChessMove(p.tile, t)));

    });

    return moves;

  }

  initialiseExternalVariables() => board = ChessBoard();


  printBoard(){

    print('  -------------------------------');

    for (int j = 7 ; j >= 0 ; j --){

      String string = ' | ';

      for (int i = 0 ; i < 8 ; i ++){
        Tile tile = board.tile(i, j);

        if (tile.pieces.isNotEmpty) string += tile.pieces.first.name;
        else string += ' ';

        string += ' | ';

      }

      print(string + '\n');

      print('  -------------------------------');

    }

    print('\n' +  '\n');
  }

  PlayerOrder get playerOrder => PlayerOrder.sequential;

  setExternalVariables(String string) {}

  setFirstPlayer(String firstPlayer) {
   super.setFirstPlayer(firstPlayer);

   whitePlayer = playerQueue[0];
   blackPlayer = playerQueue[1];
  }

  @override
  setUpNewPosition() {}

  @override
  double value(String playerId) {
    // TODO: implement value
    return null;
  }




}
