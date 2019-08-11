part of game;

abstract class Position {
  GameEvent lastMove;

  GameDependency get dependency;

  String gameId;
  List<String> playerIds;
  List<String> playerQueue;
  int get playerIndex => playerIds.indexOf(playerId);

  List<Position> children = List();
  Position topChild;
  Position parent;
  bool expanded = false;

  List<double> _absoluteValues;
  List<double> get absoluteValues => _absoluteValues;

  set absoluteValues(List<double> values) {
    _absoluteValues = values;

    relativeValues = List(values.length);

    for (int i = 0; i < values.length; i++) {
      relativeValues[i] = _value(i);
    }
  }

  List<double> relativeValues;

  double value(int player) {
    if (topChild == null)
      return relativeValues[player];
    else
      return relativeValues[player] + topChild.value(player);
  }

  PositionBuilder get positionBuilder => dependency.getPositionBuilder();
  MoveBuilder get moveBuilder => dependency.getMoveBuilder();

  int get nextMoveNumber => lastMove == null ? 0 : lastMove.number + 1;

  PlayerVariable<PlayerStatus> playerStatus;
  PlayerVariable<double> score;
  PlayerVariable<double> timeLeft;
  PlayerVariable<int> color;

  String get json => jsonEncode({
        'game_id': gameId,
        'player_ids': playerIds.join(','),
        'player_queue': playerQueue.join(','),
        'player_status': playerStatus.string,
//    'time_left': timeLeft.string,
        'score': score.string,
        'color': color.string,
        'last_move': lastMove == null ? StartingPosition.type : lastMove.string,
        'move_number': lastMove == null ? 0 : lastMove.number,
        'position': externalVariablesString,
      });

  setVariables(String posJson) {
    var jsonObject = jsonDecode(posJson);

    gameId = jsonObject['game_id'];
    playerIds = jsonObject['player_ids'].split(',');
    playerQueue = jsonObject['player_queue'].split(',');
    playerStatus =
        PlayerVariable.playerVariablefromString(jsonObject['player_status']);
//        timeLeft = PlayerVariable.playerVariablefromString( jsonObject['time_left']);
    score = PlayerVariable.playerVariablefromString(jsonObject['score']);
    color = PlayerVariable.playerVariablefromString(jsonObject['color']);

    setExternalVariables(jsonObject['position']);

    //lastmove

    int lastMoveInt = jsonObject['move_number'];

    if (lastMoveInt == 0) {
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

  makeMove(Move move) {
    move.go(this);

    move.number = nextMoveNumber;

    lastMove = move;

    analyse();

    setValues();

    if (playerStatus[playerId] == PlayerStatus.out) move.suicide = true;

    nextPlayer();

    move.resultingPosition = json;
  }

  nextPlayer() {
    setNextPlayer();

    if (playerQueue.length < 2 && playerIds.length > 1) {
      gameOver = true;

      if (playerQueue.length == 1) winner = playerQueue[0];
    }

    if (!gameOver) {
      setUpNewPosition();
    }
  }

  setNextPlayer() {
    switch (playerOrder) {
      case PlayerOrder.sequential:
        String p = playerQueue.removeAt(0);
        if (playerStatus[p] == PlayerStatus.playing) playerQueue.add(p);
        break;

      case PlayerOrder.random:
        String p = playerQueue[0];
        if (playerStatus[p] != PlayerStatus.playing) playerQueue.remove(p);
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

  initialise() {
    playerStatus = PlayerVariable(playerIds, PlayerStatus.ingameNotReady);
    score = PlayerVariable(playerIds, 0);

    color = PlayerVariable.fromList(playerIds, Palette.defaultPlayerColours);

    initialiseExternalVariables();

    if (playerQueue == null) {
      playerQueue = List();
      playerIds.forEach((p) => playerQueue.add(p));
    }

    setValues();

    lastMove = StartingPosition(json);
  }

  setTimers(double gameTime) => timeLeft = PlayerVariable(playerIds, gameTime);

  initialiseExternalVariables();

  setFirstPlayer(bool random, String firstPlayer) {
    if (firstPlayer != null) {
      if (playerIds.contains(firstPlayer)) {
        bool found = playerQueue.remove(firstPlayer);
        if (found) playerQueue.insert(0, firstPlayer);
      }
    } else {
      if (random == true) playerQueue.shuffle();
    }
  }

  setUpNewPosition();

  analyse();

  List<Move> getPossibleMoves();

  Stream<Move> listenForMoves() {}

  printBoard() {}

  double valuationOfPlayer(String playerId);

  setValues() {
    List<double> values = List(playerIds.length);

    for (int i = 0; i < values.length; i++) {
      values[i] = valuationOfPlayer(playerIds[i]);
    }

    absoluteValues = values;
  }

  double _value(int index) {
    double value;

    if (absoluteValues.length == 1) {
      value = absoluteValues[0];
    } else if (absoluteValues.length == 2) {
      if (index == 0)
        value = absoluteValues[0] - absoluteValues[1];
      else
        value = absoluteValues[1] - absoluteValues[0];
    } else {
      double highestOpponent =
          index == 0 ? absoluteValues[1] : absoluteValues[0];

      for (int i = 0; i < absoluteValues.length; i++) {
        if (i == index) continue;

        if (absoluteValues[i] > highestOpponent)
          highestOpponent = absoluteValues[i];
      }

      value = absoluteValues[index] - highestOpponent;
    }

    return value;
  }

  static String playerStatusToString(PlayerStatus p) {
    switch (p) {
      case PlayerStatus.winner:
        return 'winner';

      case PlayerStatus.disconnected:
        return 'disconnected';

      case PlayerStatus.out:
        return 'out';

      case PlayerStatus.ingameNotReady:
        return 'waiting';

      case PlayerStatus.ready:
        return 'ready';

      case PlayerStatus.playing:
        return 'playing';

      case PlayerStatus.queuing:
        return 'queuing';
        break;
    }
  }

  makeChildren() async {
    var moves = getPossibleMoves();

    moves.forEach((m) {
      Position child = duplicate;
      child.parent = this;

      if (m.check(child) is! GameError) {
        child.makeMove(m);

        if (!m.suicide) children.add(child);
      }
    });

    sortChildren();
    expanded = true;
  }

  sortChildren() {
    children
        .sort((a, b) => b.value(playerIndex).compareTo(a.value(playerIndex)));

    bool topChildChanged = false;

    Position newTopChild = children[0];
    if (newTopChild != topChild) topChildChanged = true;

    topChild = newTopChild;

    if (topChildChanged && parent != null) parent.sortChildren();
  }

  findTopChild(Position position) {
    if (children.isEmpty)
      return;
    else if (children.length == 1) {
      topChild = children.first;
    } else {
      topChild = children[0];
      double bestValue = topChild.relativeValues[playerIndex];

      children.forEach((c) {
        double childValue = c.relativeValues[playerIndex];

        if (childValue > bestValue) {
          topChild = c;
          bestValue = childValue;
        }
      });
    }
  }

  static PlayerStatus playerStatusFromString(String string) {
    switch (string) {
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

enum PlayerOrder { sequential, random, firstToPlay, highestScore, lowestScore }
