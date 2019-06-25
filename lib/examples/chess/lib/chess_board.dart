part of chess;



class ChessBoard extends Board{

  List<Piece> whiteArmy = List();
  List<Piece> blackArmy = List();

  ChessBoard.empty() : super.squareTiles(8, ConnectionScheme.allDirections);
  
  ChessBoard() : super.squareTiles(8, ConnectionScheme.allDirections){
    
    //j = vertical
    // i is horizontal
    // white home is row j = 0 and j = 1
    // black home is row j = 6 and j = 7

    for(int i = 0; i < 8 ; i ++){
      Pawn white = Pawn(this);
      white.startingPosition = tile(i, 1);
      whiteArmy.add(white);

      Pawn black = Pawn(this);
      black.startingPosition = tile(i, 6);
      blackArmy.add(black);
    }

    // finish white army

    Rook whiteRookLeft = Rook(this);
    Rook whiteRookRight = Rook(this);
    whiteRookLeft.startingPosition = tile(0, 0);
    whiteRookRight.startingPosition = tile(7, 0);
    whiteArmy.add(whiteRookLeft);
    whiteArmy.add(whiteRookRight);

    Knight whiteKnightLeft = Knight(this);
    Knight whiteKnightRight = Knight(this);
    whiteKnightLeft.startingPosition = tile(1, 0);
    whiteKnightRight.startingPosition = tile(6, 0);
    whiteArmy.add(whiteKnightLeft);
    whiteArmy.add(whiteKnightRight);

    Bishop whiteBishopLeft = Bishop(this);
    Bishop whiteBishopRight = Bishop(this);
    whiteBishopLeft.startingPosition = tile(2, 0);
    whiteBishopRight.startingPosition = tile(5, 0);
    whiteArmy.add(whiteBishopLeft);
    whiteArmy.add(whiteBishopRight);

    Queen whiteQueen = Queen(this);
    whiteQueen.startingPosition = tile(3, 0);
    whiteArmy.add(whiteQueen);

    King whiteKing = King(this);
    whiteKing.startingPosition = tile(4, 0);
    whiteArmy.add(whiteKing);

    // black army

    Rook blackRookLeft = Rook(this);
    Rook blackRookRight = Rook(this);
    blackRookLeft.startingPosition = tile(0, 7);
    blackRookRight.startingPosition = tile(7, 7);
    blackArmy.add(blackRookLeft);
    blackArmy.add(blackRookRight);

    Knight blackKnightLeft = Knight(this);
    Knight blackKnightRight = Knight(this);
    blackKnightLeft.startingPosition = tile(1, 7);
    blackKnightRight.startingPosition = tile(6, 7);
    blackArmy.add(blackKnightLeft);
    blackArmy.add(blackKnightRight);
    Bishop blackBishopLeft = Bishop(this);
    Bishop blackBishopRight = Bishop(this);
    blackBishopLeft.startingPosition = tile(2, 7);
    blackBishopRight.startingPosition = tile(5, 7);
    blackArmy.add(blackBishopLeft);
    blackArmy.add(blackBishopRight);

    Queen blackQueen = Queen(this);
    blackQueen.startingPosition = tile(3, 7);
    blackArmy.add(blackQueen);

    King blackKing = King(this);
    blackKing.startingPosition = tile(4, 7);
    blackArmy.add(blackKing);

    whiteArmy.forEach((p) {
      p.tile = p.startingPosition;
      (p as ChessPiece).chessColor = ChessColor.white;
    }) ;

    blackArmy.forEach((p) {

      p.tile = p.startingPosition;
      (p as ChessPiece).chessColor = ChessColor.black;
    } );
    
    
    
    
  }
  
  
  
}