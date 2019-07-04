part of game;


abstract class Player{
  static const int human = 0;
  static const int computer = 1;
  static const int internet = 2;

  Game game;
  String id;
  String displayName;
  String gameId;

  Timer timer;
  Stopwatch stopwatch = Stopwatch();

  set status (PlayerStatus newStatus) => game.position.playerStatus[id] = newStatus;

  PlayerStatus get status => game == null ? PlayerStatus.queuing : game.position.playerStatus[id];

  initialise(){

    game.position.playerStatus[id] = status;

    if(game.gameId == 'local game') status = PlayerStatus.ready;

  }

  moveUpdate(MakeMove move)=> game.confirmMove(id, move.number);


  yourTurn(){
    timer = Timer(Duration(milliseconds: (game.position.timeLeft[id] * 1000).round()), (){
      outOfTime();
    });

    stopwatch.reset();
    stopwatch.start();

    go();
  }

  go();

  stopTimer(){
    stopwatch.stop();
    timer?.cancel();
    game.position.timeLeft[id] -= stopwatch.elapsed.inSeconds;
    stop();
  }

  stop();

  wait(){  }

  gameStarted(String gameId){}

  outOfTime(){
    game.position.playerStatus[id] = PlayerStatus.out;
    game.position.nextPlayer();
  }

  tidyUp(){}
}


enum PlayerStatus{
  queuing,
  winner,
  disconnected,
  out,
  ingameNotReady,
  ready,
  playing
}