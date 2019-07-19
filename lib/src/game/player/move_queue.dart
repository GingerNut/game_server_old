part of game;


class MoveQueue{

  String player;
  final Position position;

  get dependency => position.dependency;

  List<MoveLine> toExpand = List();

  List<MoveLine> lines = List();

  MoveQueue(this.position){
    player = position.playerId;

     position.lastMove.makeChildren(position.dependency);

     position.lastMove.children.forEach((c){

       MoveLine moveLine = MoveLine(player,position.playerIds,c);

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


  expandLine(MoveLine line, int depth){

    lines.remove(line);

    line.end.makeChildren(position.dependency);

    if(line.end.children.isEmpty) return;

    line.end.children.forEach((c) {
      lines.add(line.getChild(c));
    }
    );

  }


  expandTopLines(int number, int depth){

    List<MoveLine> newlines = List();
    List<MoveLine> kill = List();

    for (int i = 0 ; i < number ; i ++){
      if(i > lines.length -1) break;

      Move move = lines[i].end;
      kill.add(lines[i]);

      move.makeChildren(position.dependency);

      move.children.forEach((m) {

        newlines.add(lines[i].getChild(m));
      } );
    }

    kill.forEach((l)=> lines.remove(l));

    newlines.forEach((l) => lines.add(l));

    sort();

  }

  expandAll(int depth){


    List<MoveLine> newlines = List();


    lines.forEach((l){

      l.end.makeChildren(dependency);

      l.end.children.forEach((m)=> newlines.add(l.getChild(m)));

    });

    lines.clear();

    newlines.forEach((l) => lines.add(l));

    sort();


  }


  printQueue(){

    String string = '\n${position.dependency.name} move queue: \n\n';

    string += 'Number, Net Value, Move (abs value) ...  Responses (abs value)\n';
    string += '-------------------------------------------------------------\n';

    int index = 0;

    lines.forEach((l) {

      string += 'Line ${index ++}: ';
      string += l.value.toString();
      string += '  ';
      string += l.start.string;
      string += ' (${l.start.absoluteValue(l.player, position.playerIds).toString()}): ';

      for (int i = 1 ; i < l._moves.length; i ++){
        Move m = l._moves[i];

        string += m.string;
        string += ' (${m.absoluteValue(player, position.playerIds).toString()}) ';
        string +=  '  ';
      }

      string += '\n';

    } );

    string+= '\n';

    print(string);
  }


}