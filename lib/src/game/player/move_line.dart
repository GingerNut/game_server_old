part of game;

class MoveLine{

  final String player;
  final Position position;
  final MoveQueue lines;

  double _value;

  double get value {
    if(_value != null) return _value;

    _value = 0;

    _moves.forEach((m) {
      _value += m.absoluteValue(player, position.playerIds);
    });

    return _value;
  }

  int get depth => _moves.length;

  Move get start => _moves.first;
  Move get end => _moves.last;

  List<Move> _moves = List();

  MoveLine(this.player, this.position, this.lines, List<Move> moves, Move lastMove){
    moves.forEach((m) => this._moves.add(m));
    this._moves.add(lastMove);
  }

  expand(int depth){
    if(this.depth >= depth) return;

    lines.remove(this);

    end.makeChildren(position.dependency);

    if(end.children.isEmpty) return;

    end.children.forEach((c) {
      lines.add(MoveLine(player, position, lines, _moves, c));
    }
    );

  }

}