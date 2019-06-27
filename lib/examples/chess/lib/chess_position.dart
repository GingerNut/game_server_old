part of chess;

class ChessPosition extends Position{

  ChessBoard board;

  String whitePlayer;
  String blackPlayer;

  ChessColor get playerColor => whitePlayer == playerId ? ChessColor.white : ChessColor.black;

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

  String get externalVariablesString {
    String string = '';

    board.whiteArmy.forEach((p) {
      string += p.name;
      string += p.tile.i.toString();
      string += p.tile.j.toString();
      string += Message.internalDelimiter;
    });

    string += Message.delimiter;

    board.blackArmy.forEach((p) {
      string += p.name;
      string += p.tile.i.toString();
      string += p.tile.j.toString();
      string += Message.internalDelimiter;
    });

    return string;
  }

  setExternalVariables(String s) {

    makePiece(String string, ChessColor color) {

      setCoords(String string, ChessPiece piece) {
        int i = int.parse(s.substring(1, 2));
        int j = int.parse(s.substring(2, 3));

        piece.tile = board.tile(i, j);
      }

      switch (s.substring(0, 1)) {
        case 'P':
          var p = Pawn(board);
          setCoords(s, p);
          break;

        case 'R':
          var p = Rook(board);
          setCoords(s,p);
          break;

        case 'N':
          var p = Knight(board);
          setCoords(s,p);
          break;

        case 'B':
          var p = Bishop(board);
          setCoords(s,p);
          break;

        case 'K':
          var p = King(board);
          setCoords(s,p);
          break;

        case 'Q':
          var p = Queen(board);
          setCoords(s,p);
          break;
      }
    }

    board = ChessBoard();

    List<String> details = s.split(Message.delimiter);

    List<String> white = details[0].split(Message.internalDelimiter);

    white.forEach((s) => makePiece(s, ChessColor.white));

    List<String> black = details[1].split(Message.internalDelimiter);

    black.forEach((s) => makePiece(s, ChessColor.black));

  }




  List<Move> getPossibleMoves() {
    List<Move> moves = List();

    List<Piece> army;

    if(playerId == whitePlayer) army = board.whiteArmy;
    else army = board.blackArmy;

    army.forEach((p){

      List<Tile> tiles = p.legalMoves;

      tiles.forEach((t) => moves.add(ChessMove(p.tile, t)));

    });

    print(moves);

    return moves;

  }

  initialiseExternalVariables() {
    board = ChessBoard();
    board.startingPosition();
  }


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
