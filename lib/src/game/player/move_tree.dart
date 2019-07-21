part of game;

class MoveTree{

  MoveTree top;
  Move get bestMove => bestBranch.move;
  MoveTree bestBranch;
  int depth;
  int index;

  BranchQuality branchQuality = BranchQuality.noYetExamined;

  Queue<Job> jobs = Queue();

  final Position root;
  Move get move => root.lastMove;
  int playerIndex;

  MoveTree(this.top, this.root){
    playerIndex = root.playerIds.indexOf(root.playerId);
    if(top == null) top = this;
    index = root.playerIds.indexOf(root.playerId);
  }

  double valueNoMove(int index){

    return root.relativeValues[index];
  }

  double value(int index){

    sortBranches(0);

    double value = root.relativeValues[index];

    if(bestBranch != null) value += bestBranch.root.relativeValues[index];

    return value;
  }

  bool get isEmpty => branches.isEmpty;

  List<MoveTree> branches = List();

  findBranches() {
    var moves = root.getPossibleMoves();

    if (moves.isEmpty) {

      branchQuality = BranchQuality.noMovesPossible;

    };

    moves.forEach((m) {
      Position position = root.duplicate;

      if (m.check(root) is !GameError) {

        position.makeMove(m);

        if (!m.suicide) branches.add(MoveTree(top, position));
      }
    });

    branchQuality = BranchQuality.notEvaluated;

    findTopBranch();

  }

  sortBranches(int sortDepth){

//    print('From sort depth: ' + sortDepth.toString());

    branches.forEach((b) => b.sortBranches(sortDepth++));

    findTopBranch();

  }

  findTopBranch(){

    if(branches.isEmpty) return;

    else if(branches.length == 1){

      bestBranch = branches.first;

    } else{

      bestBranch = branches[0];
      double value = bestBranch.root.relativeValues[root.playerIds.indexOf(bestBranch.root.playerId)];

      branches.forEach((b) {
        double branchValue = b.root.relativeValues[root.playerIds.indexOf(b.root.playerId)];

        if(branchValue > value){
          bestBranch = b;
          value = branchValue;
        }

      });
    }
  }

  search([int depth = 100]){

    //TODO jobs - first analytise all to depth 4 then explore top move

    //TODO valuation needs to be by looking at value from the point of view of the position player

    orderTree();

    this.depth = depth;

    MoveTree tree = bestBranch;
    int index = 1;

    while(tree.bestBranch != null && index < depth){
      tree = tree.bestBranch;
      index ++;
    }

    tree.findBranches();



  }

  orderTree(){
    findTopBranch();

    MoveTree tree = bestBranch;





  }

  printTree(){

    String string = '\n${root.dependency.name} move tree: \n\n';

    string += 'Number, Net Value, Move (abs value) ...  Responses (abs value)\n';
    string += '-------------------------------------------------------------\n';

    int branch = 0;

    branches.forEach((b) {

      string += 'Line ${branch ++}: ';
      string += b.value(playerIndex).toString();
      string += '  ';
      string += b.move.string;
      string += ' (${b.value(playerIndex).toString()}): ';

      MoveTree tree = bestBranch;
      int index = 1;

      while(tree.bestBranch != null && index < depth){
        tree = tree.bestBranch;
        index ++;

        string += ' ';

        string += tree.value(playerIndex).toString();

        string += ' ';

      }

      string += '\n';

    } );

    string+= '\n';

    print(string);
  }
  
}

abstract class Job{




}



enum BranchQuality{noYetExamined, notEvaluated, good, noMovesPossible, bad}




