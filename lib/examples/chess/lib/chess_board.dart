part of chess;



class ChessBoard extends Board{

  List<Piece> whiteArmy = List();
  List<Piece> blackArmy = List();

  ChessBoard.empty() : super.squareTiles(8, ConnectionScheme.allDirections);
  
  ChessBoard() : super.squareTiles(8, ConnectionScheme.allDirections);



  startingPosition(){
    //j = vertical
    // i is horizontal
    // white home is row j = 0 and j = 1
    // black home is row j = 6 and j = 7

    for(int i = 0; i < 8 ; i ++){
      Pawn white = Pawn(this);
      white.tile = tile(i, 1);
      whiteArmy.add(white);

      Pawn black = Pawn(this);
      black.tile = tile(i, 6);
      blackArmy.add(black);
    }

    // finish white army

    Rook whiteRookLeft = Rook(this);
    Rook whiteRookRight = Rook(this);
    whiteRookLeft.tile = tile(0, 0);
    whiteRookRight.tile = tile(7, 0);
    whiteArmy.add(whiteRookLeft);
    whiteArmy.add(whiteRookRight);

    Knight whiteKnightLeft = Knight(this);
    Knight whiteKnightRight = Knight(this);
    whiteKnightLeft.tile = tile(1, 0);
    whiteKnightRight.tile = tile(6, 0);
    whiteArmy.add(whiteKnightLeft);
    whiteArmy.add(whiteKnightRight);

    Bishop whiteBishopLeft = Bishop(this);
    Bishop whiteBishopRight = Bishop(this);
    whiteBishopLeft.tile = tile(2, 0);
    whiteBishopRight.tile = tile(5, 0);
    whiteArmy.add(whiteBishopLeft);
    whiteArmy.add(whiteBishopRight);

    Queen whiteQueen = Queen(this);
    whiteQueen.tile = tile(3, 0);
    whiteArmy.add(whiteQueen);

    King whiteKing = King(this);
    whiteKing.tile = tile(4, 0);
    whiteArmy.add(whiteKing);

    // black army

    Rook blackRookLeft = Rook(this);
    Rook blackRookRight = Rook(this);
    blackRookLeft.tile = tile(0, 7);
    blackRookRight.tile = tile(7, 7);
    blackArmy.add(blackRookLeft);
    blackArmy.add(blackRookRight);

    Knight blackKnightLeft = Knight(this);
    Knight blackKnightRight = Knight(this);
    blackKnightLeft.tile = tile(1, 7);
    blackKnightRight.tile = tile(6, 7);
    blackArmy.add(blackKnightLeft);
    blackArmy.add(blackKnightRight);
    Bishop blackBishopLeft = Bishop(this);
    Bishop blackBishopRight = Bishop(this);
    blackBishopLeft.tile = tile(2, 7);
    blackBishopRight.tile = tile(5, 7);
    blackArmy.add(blackBishopLeft);
    blackArmy.add(blackBishopRight);

    Queen blackQueen = Queen(this);
    blackQueen.tile = tile(3, 7);
    blackArmy.add(blackQueen);

    King blackKing = King(this);
    blackKing.tile = tile(4, 7);
    blackArmy.add(blackKing);

    whiteArmy.forEach((p) {
      (p as ChessPiece).chessColor = ChessColor.white;
    }) ;

    blackArmy.forEach((p) {
      (p as ChessPiece).chessColor = ChessColor.black;
    } );
    
    tiles.forEach((t) => t.label = labelTile(t));
    
    
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
  
  
  
}