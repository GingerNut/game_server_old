
import 'dart:async';
import 'dart:isolate';

import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/command/tidy.dart';

import '../player.dart';
import '../position.dart';

class Computer{

    final ReceivePort receivePort;
    final SendPort sendPort;

    Position position;

  Computer(this.receivePort, this.sendPort);

    initialise()async{
        receivePort.listen((s) => handleMessage(s));

        await setupPosition();

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




        }


    }

    }








