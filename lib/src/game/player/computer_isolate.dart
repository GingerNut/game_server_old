
import 'dart:async';
import 'dart:isolate';

import 'package:game_server/src/messages/command/echo.dart';
import 'package:game_server/src/messages/command/make_move.dart';
import 'package:game_server/src/messages/command/send_position.dart';
import 'package:game_server/src/messages/command/setId.dart';
import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/command/tidy.dart';

import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/messages/command/your_turn.dart';
import 'package:game_server/src/messages/message.dart';

import '../move.dart';
import '../move_builder.dart';
import '../position.dart';
import '../position_builder.dart';



abstract class ComputerIsolate{

    bool ready = false;
    String gameId;
    String playerId;
    final ReceivePort receivePort;
    final SendPort sendPort;

    Position position;
    MoveBuilder get moveBuilder;
    PositionBuilder get positionBuilder;

  ComputerIsolate(this.receivePort, this.sendPort){
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
            Position position = sendPosition.build(positionBuilder);
            gameId = position.gameId;
            await analysePosition(position);
            ready = true;
            break;

          case YourTurn:
            yourTurn(string);
            break;

          case MakeMove:
            MakeMove makeMove = message as MakeMove;
            Move move = makeMove.build(moveBuilder);
            doMove(move);
            break;

          default:


        }

    }

    send(Message message) {
      sendPort.send(message.json);
    }

    Future analysePosition(Position position);

    doMove(Move move){
      position.makeMove(move);
    }

    yourTurn(String details);

    findBestMove();

    }








