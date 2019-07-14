part of game;

class MoveLine{

  final String player;
  final Position position;
  final MoveQueue lines;

  double _value;

  double get value {
    if(_value != null) return _value;

    _value = 0;

    moves.forEach((m) {
      _value += m.absoluteValue(player, position.playerIds);
    });

    return _value;
  }

  int depth;

  Move get start => moves.first;
  Move get end => moves.last;

  List<Move> moves = List();

  MoveLine(this.player, this.position, this.lines, List<Move> moves, Move lastMove){
    moves.forEach((m) => this.moves.add(m));
    this.moves.add(lastMove);
  }

  expand(){
    lines.remove(this);

    end.makeChildren(position.dependency);

    if(end.children.isEmpty) return;

    end.children.forEach((c) {
      lines.add(MoveLine(player, position, lines, moves, c));
    }
    );

  }

}