
import 'dart:async';
import 'dart:isolate';

import 'package:game_server/src/messages/command/command.dart';
import 'package:game_server/src/messages/command/send_game.dart';
import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/command/tidy.dart';

import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/messages/command/your_turn.dart';

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

        sendPort.send(SetStatus(PlayerStatus.ready).string);
    }





    handleMessage(String string) async{

        String type = string.substring(0,3);
        String details = string.substring(3);

        switch(type){

            case Tidy.code:
                receivePort.close();
                break;

          case Command.echo:
            sendPort.send('echo ' + details);
            break;

          case SendGame.code:
            await createPosition(details);
            ready = true;
            break;

          case YourTurn.code:
            yourTurn(details);
            break;

          case Move.code:
            doMove(details);
            break;

          default:


        }

    }

    Future createPosition(String details);

    doMove(String details);

    yourTurn(String details);

    findBestMove();

    }








