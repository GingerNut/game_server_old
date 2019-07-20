
part of game;

abstract class Position{

  GameEvent lastMove;

  GameDependency get dependency;

  String gameId;
  List<String> playerIds;
  List<String> playerQueue;
  List<double> values;

  PositionBuilder get positionBuilder => dependency.getPositionBuilder();
  MoveBuilder get moveBuilder => dependency.getMoveBuilder();

  int get nextMoveNumber => lastMove == null ? 0 : lastMove.number +1;

  PlayerVariable<PlayerStatus> playerStatus;
  PlayerVariable<double> score;
  PlayerVariable<double> timeLeft;
  PlayerVariable<int> color;

  String get json => jsonEncode({
    'game_id' : gameId,
    'player_ids' : playerIds.join(','),
    'player_queue' : playerQueue.join(','),
    'player_status' : playerStatus.string,
//    'time_left': timeLeft.string,
    'score' : score.string,
    'color': color.string,
    'last_move' : lastMove == null ? StartingPosition.type : lastMove.string,
    'move_number' : lastMove == null ? 0 : lastMove.number,
    'position' : externalVariablesString,
  }
  );

  setVariables(String posJson){
    var jsonObject = jsonDecode(posJson);

    gameId = jsonObject['game_id'];
    playerIds = jsonObject['player_ids'].split(',');
    playerQueue = jsonObject['player_queue'].split(',');
    playerStatus = PlayerVariable.playerVariablefromString(jsonObject['player_status']);
//        timeLeft = PlayerVariable.playerVariablefromString( jsonObject['time_left']);
    score = PlayerVariable.playerVariablefromString(jsonObject['score']);
    color = PlayerVariable.playerVariablefromString(jsonObject['color']);

    setExternalVariables(jsonObject['position']);

    //lastmove

    int lastMoveInt = jsonObject['move_number'];

    if(lastMoveInt == 0) {
      lastMove = StartingPosition(posJson);
    } else {

      lastMove = moveBuilder.build(jsonObject['last_move']);
      lastMove.number = lastMoveInt;

    }


  }

  String get externalVariablesString;

  setExternalVariables(String string);

  Position get duplicate => positionBuilder.build(json);

  String get playerId => playerQueue[0];

  PlayerOrder get playerOrder;

  String winner;
  bool gameOver = false;

  bool canPlay(String id);

  makeMove(Move move){

    move.go(this);

    move.number = nextMoveNumber;

    lastMove = move;

    analyse();

    values = List(playerIds.length);

    for (int i = 0 ; i < playerIds.length ; i ++){

      values[i] = valuationOfPlayer(playerIds[i]);

    }

    if(playerStatus[playerId] == PlayerStatus.out) move.suicide = true;

    nextPlayer();

    move.resultingPosition = json;

  }

  nextPlayer(){

    setNextPlayer();

    if(playerQueue.length < 2 && playerIds.length > 1){
      gameOver = true;

      if(playerQueue.length == 1) winner = playerQueue[0];

    }

    if (!gameOver) {

      setUpNewPosition();
    }
  }


  setNextPlayer(){

    switch(playerOrder){
      case PlayerOrder.sequential:

        String p = playerQueue.removeAt(0);
        if(playerStatus[p] == PlayerStatus.playing) playerQueue.add(p);
        break;

      case PlayerOrder.random:
        String p = playerQueue[0];
        if(playerStatus[p] != PlayerStatus.playing) playerQueue.remove(p);
        playerQueue.shuffle();
        break;

      case PlayerOrder.firstToPlay:
      // TODO: Handle this case.
        break;

      case PlayerOrder.highestScore:
      // TODO: Handle this case.
        break;

      case PlayerOrder.lowestScore:
      // TODO: Handle this case.
        break;
    }

  }

  initialise(){
    playerStatus = PlayerVariable(playerIds, PlayerStatus.ingameNotReady);
    score = PlayerVariable(playerIds, 0);

    color = PlayerVariable.fromList(playerIds, Palette.defaultPlayerColours);

    initialiseExternalVariables();

    if(playerQueue == null) {
      playerQueue = List();
      playerIds.forEach((p)=>playerQueue.add(p));
    }



    lastMove = StartingPosition(json);
  }

  setTimers(double gameTime)=> timeLeft = PlayerVariable(playerIds, gameTime);

  initialiseExternalVariables();

  setFirstPlayer(bool random, String firstPlayer){
    if (firstPlayer != null) {
      if (playerIds.contains(firstPlayer)) {

        bool found = playerQueue.remove(firstPlayer);
        if(found) playerQueue.insert(0, firstPlayer);
      }
    } else {
      if(random == true) playerQueue.shuffle();

    }
  }

  setUpNewPosition();

  analyse();

  List<Move> getPossibleMoves();

  Stream<Move> listenForMoves(){}

  printBoard(){}

  double valuationOfPlayer(String playerId);

  double value(String player){
    int index = playerIds.indexOf(player);

    double value;

    if(values.length == 1){
      value =  values[0];

    } else if(values.length == 2){

      if(index == 0) value = values[0] - values[1];
      else value = values[1] - values[0];

    } else {

      double highestOpponent = index == 0 ? values[1] : values[0];

      for (int i = 0 ; i < values.length ; i ++){
        if(i == index) continue;

        if(values[i] > highestOpponent) highestOpponent = values[i];

      }

      value = values[index] - highestOpponent;
    }

    return value;

  }

  static String playerStatusToString(PlayerStatus p){

    switch (p){
      case PlayerStatus.winner:
        return 'winner';

      case PlayerStatus.disconnected:
        return'disconnected';

      case PlayerStatus.out:
        return 'out';

      case PlayerStatus.ingameNotReady:
        return 'waiting';

      case PlayerStatus.ready:
        return 'ready';

      case PlayerStatus.playing:
        return 'playing';

      case PlayerStatus.queuing:
        return'queuing';
        break;
    }

  }

  static PlayerStatus playerStatusFromString(String string){
    switch (string){
      case 'winner':
        return PlayerStatus.winner;
        break;

      case 'disconnected':
        return PlayerStatus.disconnected;
        break;

      case 'out':
        return PlayerStatus.out;
        break;

      case 'waiting':
        return PlayerStatus.ingameNotReady;
        break;

      case 'ready':
        return PlayerStatus.ready;
        break;

      case 'playing':
        return PlayerStatus.playing;
        break;

      case 'queuing':
        return PlayerStatus.queuing;
        break;
    }

  }

}


enum PlayerOrder{
  sequential,
  random,
  firstToPlay,
  highestScore,
  lowestScore
}


