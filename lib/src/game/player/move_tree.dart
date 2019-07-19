part of game;

class MoveTree{

  Branch root;

  bool get isEmpty => branches.isEmpty;

  List<MoveTree> branches = List();

}



class Branch{

  final Move move;

  Branch(this.move);



}