part of game;

class Computer{

    bool ready = false;
    String gameId;
    String playerId;
    final ReceivePort receivePort;
    final SendPort sendPort;

    Position position;
    MoveBuilder get moveBuilder => dependency.getMoveBuilder();
    PositionBuilder get positionBuilder => dependency.getPositionBuilder();
    GameDependency dependency;

  Computer(this.dependency, this.receivePort, this.sendPort){
    receivePort.listen((s) => handleMessage(s));
  }

    initialise()async{

        while(!ready ){
          await Future.delayed(Duration(milliseconds : 100));
        }

        send(SetStatus(PlayerStatus.ready));
    }

    handleMessage(String string) async{

      Message message = Message.inflate(string);

        switch(message.runtimeType){

            case Tidy:
                receivePort.close();
                break;

          case Echo:
            var echo = message as Echo;
            send(echo.response);
            break;

          case SetId:
            var setid = message as SetId;
            playerId = setid.text;
            break;

          case SendPosition:
            SendPosition sendPosition = message as SendPosition;
            position = sendPosition.build(positionBuilder);
            gameId = position.gameId;
            await analysePosition(position);
            ready = true;
            break;

          case GameStarted:
            position.playerIds.forEach((p) => position.playerStatus[p] = PlayerStatus.playing);
            break;

          case YourTurn:
            Move move = await findBestMove();
            MakeMove makeMove = MakeMove(gameId, playerId, move , move.number);
            send(makeMove);
            break;

          case MakeMove:
            MakeMove makeMove = message as MakeMove;
            Move move = makeMove.build(moveBuilder);
            doMove(move);
            send(ConfirmMove(makeMove.number, makeMove.gameId, playerId));
            break;

          default:


        }

    }

    send(Message message) => sendPort.send(message.json);

    Future analysePosition(Position position) => position.analyse();

    doMove(Move move)=> position.makeMove(move);

    Future<Move> findBestMove() async{

      Move bestMove;

      List<Move> moves = position.getPossibleMoves();

      moves.forEach((m){

        Position trialPosition = position.duplicate;
        trialPosition.makeMove(m);
        m.trialPosition = trialPosition;

      });

      double bestscore = -1000;
      bestMove = moves[0];

      moves.forEach((m) {
        double score = m.trialPosition.score[playerId];

        if(score > bestscore) {
          bestscore = score;
          bestMove = m;

        }

      });

      return bestMove;
    }

    }








