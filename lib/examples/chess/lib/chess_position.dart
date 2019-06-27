part of chess;

class ChessPosition extends Position{

  ChessBoard board;

  String whitePlayer;
  String blackPlayer;

  ChessColor get playerColor => whitePlayer == playerId ? ChessColor.white : ChessColor.black;

  @override
  analyse() {

  }

  @override
  bool canPlay(String id) => (playerId == id);

  GameDependency get dependency => ChessInjector();

  String get externalVariablesString {


    List<String> whiteList = List();

    board.whiteArmy.forEach((p) {
      String string = '';
      string += p.name;
      string += p.tile.i.toString();
      string += p.tile.j.toString();

      whiteList.add(string);
    });

    List<String> blackList = List();

    board.blackArmy.forEach((p) {
      String string = '';
      string += p.name;
      string += p.tile.i.toString();
      string += p.tile.j.toString();

      blackList.add(string);
    });

    String string = '';

    string += whiteList.join(Message.internalDelimiter);

    string += Message.delimiter;

    string += blackList.join(Message.internalDelimiter);

    return string;
  }

  setExternalVariables(String s) {

    makePiece(String pieceString, ChessColor color, List<ChessPiece> army) {

      ChessPiece p;

      switch (pieceString.substring(0, 1)) {
        case 'P':
           p = Pawn(board);

          break;

        case 'R':
           p = Rook(board);

          break;

        case 'N':
           p = Knight(board);

          break;

        case 'B':
           p = Bishop(board);

          break;

        case 'K':
           p = King(board);

          break;

        case 'Q':
           p = Queen(board);

          break;
      }

      int i = int.parse(pieceString.substring(1, 2));
      int j = int.parse(pieceString.substring(2));

      p.tile = board.tile(i, j);

      army.add(p);
    }

    board = ChessBoard();

    List<String> details = s.split(Message.delimiter);

    List<String> white = details[0].split(Message.internalDelimiter);

    white.forEach((s) => makePiece(s, ChessColor.white, board.whiteArmy));

    List<String> black = details[1].split(Message.internalDelimiter);

    black.forEach((s) => makePiece(s, ChessColor.black, board.blackArmy));

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
    return 0;
  }




}
