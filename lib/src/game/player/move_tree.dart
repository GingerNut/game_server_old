part of game;

class MoveTree {
  Move get bestMove => root.topChild.lastMove;
  int depth;
  int index;

  final Position root;

  MoveTree(this.root);

  search(int depth, int seconds) async {
    this.depth = depth;

    bool OK = true;

    Stopwatch stopwatch = Stopwatch()..start();

    Timer timer = Timer(Duration(seconds: 1), () {
      print('move tree : time up');
      OK = false;
    });

    await root.makeChildren();

    root.children.forEach(((c) async {
      if (OK) {
        await c.makeChildren();

        c.children.forEach((cc) async {
          if (OK) {
            await cc.makeChildren();

//        cc.children.forEach((ccc) {
//          ccc.makeChildren();
//        });

          }
        });
      }
    }));

    print('move tree intermeidiate time : ' +
        stopwatch.elapsedMilliseconds.toString());

    Position child = root.topChild;
    int index = 1;

    while (child != null && index < depth && OK) {
      if (!child.expanded) {
        await child.makeChildren();
        index++;
      }

      child = child.topChild;
    }

    timer.cancel();
    print('move tree final time : ' + stopwatch.elapsedMilliseconds.toString());
    stopwatch.stop();
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

      while (child != null) {
        string += ' ';

        string += child.relativeValues[root.playerIndex].toString();

        string += ' ';

        child = child.topChild;
      }

      string += '\n';
    });

    string += '\n';

    print(string);
  }
}

abstract class Job {}

enum BranchQuality { noYetExamined, notEvaluated, good, noMovesPossible, bad }
