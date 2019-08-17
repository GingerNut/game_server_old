part of game;

class MoveTree {
  Move get bestMove => root.topChild.lastMove;
  int depth;
  int index;

  Stopwatch stopwatch;
  int milliSeconds;
  bool get timeLeft => stopwatch.elapsedMilliseconds < milliSeconds;

  final Position root;

  MoveTree(this.root);

  search(int depth, int seconds) async {
    this.depth = depth;
    milliSeconds = seconds * 1000;
    stopwatch = Stopwatch()..start();

    await root.makeChildren();

    root.children.forEach(((c) async {
      if (timeLeft) {
        await c.makeChildren();

        c.children.forEach((cc) async {
          if (timeLeft) {
            await cc.makeChildren();

            cc.children.forEach((ccc) async {
              if (timeLeft) {
                await ccc.makeChildren();
              }
            });
          }
        });
      }
    }));

    Position child = root.topChild;
    int index = 1;

    while (child != null && index < depth && timeLeft) {
      if (!child.expanded) {
        await child.makeChildren();
        index++;
      }

      child = child.topChild;
    }

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
