part of game;

class MoveLine{

  final String player;
  final Position position;
  final MoveQueue lines;

  double value;

  final Move start;
  final Move end;

  List<Move> moves;

  MoveLine(this.player, this.position, this.lines, this.start, this.end){
    value = start.compoundValue(player, position.playerIds);
  }

  doValue(){
    value = start.compoundValue(player, position.playerIds);
  }

  expand(){
    lines.remove(this);

    end.makeChildren(position.dependency);

    end.children.forEach((c) => lines.add(MoveLine(player, position, lines, start, c)));

  }

}