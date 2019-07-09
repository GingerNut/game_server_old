part of game;

class TestComputerPlayer extends Player{

  final GameDependency dependency;
  Computer computer;

  TestComputerPlayer(this.dependency);

  initialise(){
    computer = Computer(dependency);
    computer.position = game.position;
  }

  go() async{

    Move move = await computer.findBestMove();

    await game.makeMove(move, gameId, id);
  }


  stop() {

  }




}