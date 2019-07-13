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

  Move get bestMove => lines.isNotEmpty ? lines[0].moves.first : null;

  add(MoveLine line) {
    lines.add(line);
    lines.sort((a, b) => a.value.compareTo(b.value));
  }

  MoveLine get first => lines.first;
  MoveLine get last => lines.last;

  expandAll(){

    lines.forEach((l) => toExpand.add(l));

    toExpand.forEach((l) => l.expand());

    toExpand.clear();

  }


  printQueue(){

    String string = 'Move queue \n';

    lines.forEach((l) {

      string += l.value.toString();
      string += '   ';

      l.moves.forEach((m){
        string += m.string;
        string += '  ';
      });

      string += '\n';

    } );

    string+= '\n';

    print(string);
  }


}