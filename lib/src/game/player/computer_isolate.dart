
import 'dart:async';
import 'dart:isolate';

import 'package:game_server/src/messages/command/echo.dart';
import 'package:game_server/src/messages/command/game_started.dart';
import 'package:game_server/src/messages/command/make_move.dart';
import 'package:game_server/src/messages/command/send_position.dart';
import 'package:game_server/src/messages/command/setId.dart';
import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/command/start_game.dart';
import 'package:game_server/src/messages/command/tidy.dart';

import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/messages/command/your_turn.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/confirm_move.dart';


import '../../game_dependency.dart';
import '../move.dart';
import '../move_builder.dart';
import '../position.dart';
import '../position_builder.dart';



class ComputerIsolate{

    bool ready = false;
    String gameId;
    String playerId;
    final ReceivePort receivePort;
    final SendPort sendPort;

    Position position;
    MoveBuilder get moveBuilder => dependency.getMoveBuilder();
    PositionBuilder get positionBuilder => dependency.getPositionBuilder();
    GameDependency dependency;

  ComputerIsolate(this.dependency, this.receivePort, this.sendPort){
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
            position.computer = true;
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
        trialPosition.computer = true;
        trialPosition.duplicated = true;
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








