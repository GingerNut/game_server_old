part of game;

class MoveLine{

  String player;
  List<String> players;

  double _value;

  double get value {
    if(_value != null) return _value;

    _value = 0;

    _moves.forEach((m) {
      _value += m.absoluteValue(player, players);
    });

    return _value;
  }

  int get depth => _moves.length;

  Move get start => _moves.first;
  Move get end => _moves.last;

  List<Move> _moves = List();

  MoveLine(this.player, this.players, Move move){
    _moves = List();
    _moves.add(move);

  }

  MoveLine.fromMoves(this.player, this.players, List<Move> moves, Move lastMove){
    moves.forEach((m) => this._moves.add(m));
    this._moves.add(lastMove);
  }

 MoveLine getChild(Move move) =>  MoveLine.fromMoves(player, players, _moves, move);



}