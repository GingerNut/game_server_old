
import 'dart:async';
import 'dart:isolate';

import 'package:game_server/src/messages/command/echo.dart';
import 'package:game_server/src/messages/command/send_game.dart';
import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/command/tidy.dart';

import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/messages/command/your_turn.dart';
import 'package:game_server/src/messages/message.dart';

import '../move.dart';
import '../move_builder.dart';
import '../position.dart';



abstract class ComputerIsolate{

    bool ready = false;
    final ReceivePort receivePort;
    final SendPort sendPort;

    Position position;
    MoveBuilder moveBuilder;

    MoveBuilder getMoveBuilder();

  ComputerIsolate(this.receivePort, this.sendPort){
    receivePort.listen((s) => handleMessage(s));
  }

    initialise()async{

        moveBuilder = getMoveBuilder();

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

          case SendGame:
            await createPosition(string);
            ready = true;
            break;

          case YourTurn:
            yourTurn(string);
            break;

          case Move:
            doMove(string);
            break;

          default:


        }

    }

    send(Message message) {
      sendPort.send(message.json);
    }

    Future createPosition(String details);

    doMove(String details);

    yourTurn(String details);

    findBestMove();

    }








