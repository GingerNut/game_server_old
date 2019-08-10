part of game;

class MoveTree {
  Move get bestMove => root.topChild.lastMove;
  int depth;
  int index;

  final Position root;

  MoveTree(this.root);

  search(int depth, int seconds) async {
    //TODO jobs - first analytise all to depth 4 then explore top move

    //TODO valuation needs to be by looking at value from the point of view of the position player

    this.depth = depth;

    bool OK = true;

    Timer timer = Timer(Duration(seconds: seconds), () {
      OK = false;
    });

    print('from movetree search : checking the board posiition is right');
    root.printBoard();

    root.makeChildren();

    Position child = root.topChild;
    int index = 1;

    while (child != null && index < depth && OK) {
      await child.makeChildren();

      child = child.topChild;
      index++;
    }

    timer.cancel();
  }

  printTree() {
    String string = '\n${root.dependency.name} move tree: \n\n';

    string +=
        'Number, Net Value, Move (abs value) ...  Responses (abs value)\n';
    string += '-------------------------------------------------------------\n';

    int branch = 0;

    root.children.forEach((c) {
      string += 'Line ${branch++}: ';
      string += c.relativeValues[c.playerIndex].toString();
      string += '  ';
      string += c.lastMove.string;
      string += ' (${c.relativeValues[root.playerIndex].toString()}): ';

      Position child = root.topChild;
      int index = 1;

      while (child.topChild != null && index < depth) {
        child = child.topChild;
        index++;

        string += ' ';

        string += child.relativeValues[root.playerIndex].toString();

        string += ' ';
      }

      string += '\n';
    });

    string += '\n';

    print(string);
  }
}

abstract class Job {}

enum BranchQuality { noYetExamined, notEvaluated, good, noMovesPossible, bad }
