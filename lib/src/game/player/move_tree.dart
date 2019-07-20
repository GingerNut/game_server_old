part of game;

class MoveTree{
  
  Move get bestMove => bestBranch.move;
  MoveTree bestBranch;
  int depth;

  Queue<Job> jobs = Queue();

  final Position root;
  Move get move => root.lastMove;
  final String player;

  MoveTree(this.root, this.player);

  bool get isEmpty => branches.isEmpty;

  List<MoveTree> branches = List();

  double get value {

    findTopBranch();

    return root.value(player) + (bestBranch != null ? bestBranch.value : 0);
  }

  findBranches() {
    var moves = root.getPossibleMoves();

    if (moves.isEmpty) return;

    moves.forEach((m) {
      Position position = root.duplicate;

      if (true) {
        position.makeMove(m);

        if (!m.suicide) branches.add(MoveTree(position, player));
      }
    });

    findTopBranch();
  }

  findTopBranch(){

    if(branches.isEmpty) return;

    else if(branches.length == 1){

      bestBranch = branches.first;

    } else{

      bestBranch = branches[0];
      double value = bestBranch.root.value(bestBranch.root.playerId);

      branches.forEach((b) {
        double branchValue = b.root.value(b.root.playerId);

        if(branchValue > value){
          bestBranch = b;
          value = branchValue;
        }

      });
    }
  }

  search([int depth = 100]){

    this.depth = depth;

    MoveTree tree = bestBranch;
    int index = 1;

    while(tree.bestBranch != null && index < depth){
      tree = tree.bestBranch;
      index ++;
    }

    tree.findBranches();

  }
  
}

class Job{

  JobType type;



}

enum JobType {
  exploreBestBranch,
  exploreTopLevel,
  findMoreMoves
}


