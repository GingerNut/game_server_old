part of game;


class MoveQueue{

  List<MoveLine> toExpand = List();

  List<MoveLine> lines = List();

  remove(MoveLine line) => lines.remove(line);

  add(MoveLine line) {
    line.doValue();
    lines.add(line);
    lines.sort((a, b) => a.value.compareTo(b.value));
  }

  expandAll(){

    lines.forEach((l) => toExpand.add(l));

    toExpand.forEach((l) => l.expand());

    toExpand.clear();

  }


  printQueue(){

    String string = 'Move queue \n';

    lines.forEach((l) {
      string += l.value.toString();

      string += ' ';

    } );

    string+= '\n';

    print(string);
  }


}