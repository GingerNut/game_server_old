part of game;


class MoveQueue{

  final String player;
  final Position position;

  List<MoveLine> toExpand = List();

  List<MoveLine> lines = List();

  MoveQueue(this.player, this.position){
     position.lastMove.makeChildren(position.dependency);

     position.lastMove.children.forEach((c){

       MoveLine moveLine = MoveLine(player,position,this,[],c);

       lines.add(moveLine);

     });


  }

  remove(MoveLine line) => lines.remove(line);

  Move get bestMove => lines.isNotEmpty ? lines[0]._moves.first : null;

  add(MoveLine line) {
    lines.add(line);

  }

  sort(){
    lines.sort((a, b) => b.value.compareTo(a.value));
  }

  MoveLine get first => lines.first;
  MoveLine get last => lines.last;

  expandAll(int depth){

    lines.forEach((l) => toExpand.add(l));

    toExpand.forEach((l) => l.expand(depth));

    toExpand.clear();

    sort();

  }

  expandTopLine(int depth){

    lines[0].expand(depth);
    sort();

  }

  expandTopThree(int depth){

    MoveLine one = lines[0];
    MoveLine two = lines[1];
    MoveLine three = lines[2];

    one.expand(depth);
    two.expand(depth);
    three.expand(depth);
    sort();

  }


  printQueue(){

    String string = 'Move queue \n';

    lines.forEach((l) {

      string += l.value.toString();
      string += '   ';

      l._moves.forEach((m){
        string += m.string;
        string += '  ';
        string += m.absoluteValue(player, position.playerIds).toString();
        string +=  '  ';
      });

      string += '\n';

    } );

    string+= '\n';

    print(string);
  }


}