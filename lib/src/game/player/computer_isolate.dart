
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


        sendPort.send(SetStatus(PlayerStatus.ready).string);
    }

    Future setupPosition()async{

      //TODO position sharing message needed

        await Future.delayed(Duration(seconds: 1));



        return;
    }



    handleMessage(String string){

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
            createPosition(details);
            break;

          case YourTurn.code:
            createPosition(details);
            break;

          case Move.code:
            createPosition(details);
            break;

          default:


        }

    }

    createPosition(String details);

    doMove(String details);

    yourTurn(String details);

    findBestMove();

    }








