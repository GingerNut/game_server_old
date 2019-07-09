part of chess;

class ChessPosition extends Position{

  Tiles tiles;

  String whitePlayer;
  String blackPlayer;


  List<ChessPiece> whiteArmy = List();
  List<ChessPiece> blackArmy = List();

  ChessColor get playerColor => whitePlayer == playerId ? ChessColor.white : ChessColor.black;

  @override
  analyse() {

  }

  @override
  bool canPlay(String id) => (playerId == id);

  GameDependency get dependency => ChessInjector();

  String get externalVariablesString {

    List<String> whiteList = List();

    whiteArmy.forEach((p) {
      String string = '';
      string += p.name;
      string += p.tile.i.toString();
      string += p.tile.j.toString();

      whiteList.add(string);
    });

    List<String> blackList = List();

    blackArmy.forEach((p) {
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
           p = Pawn(tiles);

          break;

        case 'R':
           p = Rook(tiles);

          break;

        case 'N':
           p = Knight(tiles);

          break;

        case 'B':
           p = Bishop(tiles);

          break;

        case 'K':
           p = King(tiles);

          break;

        case 'Q':
           p = Queen(tiles);

          break;
      }

      int i = int.parse(pieceString.substring(1, 2));
      int j = int.parse(pieceString.substring(2));

      p.tile = tiles.tile(i, j);

      army.add(p);
    }

    tiles = Tiles.squareTiles(8, ConnectionScheme.allDirections);

    List<String> details = s.split(Message.delimiter);

    List<String> white = details[0].split(Message.internalDelimiter);

    white.forEach((s) => makePiece(s, ChessColor.white, whiteArmy));

    List<String> black = details[1].split(Message.internalDelimiter);

    black.forEach((s) => makePiece(s, ChessColor.black, blackArmy));

  }

  clearPieces(){

    whiteArmy.clear();
    blackArmy.clear();
    tiles.tiles.forEach((t) => t.pieces.clear());

  }




  List<Move> getPossibleMoves() {
    List<Move> moves = List();

    List<Piece> army;

    if(playerId == whitePlayer) army = whiteArmy;
    else army = blackArmy;

    army.forEach((p){

      List<Tile> tiles = p.legalMoves;

      tiles.forEach((t) => moves.add(ChessMove(p.tile, t)));

    });

    return moves;

  }

  initialiseExternalVariables() {

    String pieces = 'P01,P11,P21,P31,P41,P51,P61,P71,R00,R70,N10,N60,B20,B50,Q30,K40\nP06,P16,P26,P36,P46,P56,P66,P76,R07,R77,N17,N67,B27,B57,Q37,K47';

    setExternalVariables(pieces);

    tiles.tiles.forEach((t) => t.label = labelTile(t));

  }

  String labelTile(Tile t) {

    String label = '';

    switch(t.j){
      case 0: label += 'a';
      break;

      case 1: label += 'b';
      break;

      case 2: label += 'c';
      break;

      case 3: label += 'd';
      break;

      case 4: label += 'e';
      break;

      case 5: label += 'f';
      break;

      case 6: label += 'g';
      break;

      case 7: label += 'h';
      break;

    }

    label += (t.i + 1).toString();

    return label;

  }


  printBoard(){

    print('  -------------------------------');

    for (int j = 7 ; j >= 0 ; j --){

      String string = ' | ';

      for (int i = 0 ; i < 8 ; i ++){
        Tile tile = tiles.tile(i, j);

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



  setFirstPlayer(bool random, String firstPlayer) {
   super.setFirstPlayer(random, firstPlayer);

   whitePlayer = playerQueue[0];
   blackPlayer = playerQueue[1];
  }

  @override
  setUpNewPosition() {}

  @override
  double value(String playerId) {

  }




}
