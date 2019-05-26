import 'dart:async';
import 'dart:math';

import 'package:game_server/src/channel/channel.dart';
import 'package:game_server/src/command/command.dart';
import 'package:game_server/src/database/record.dart';

import '../../game_server.dart';

class Client implements ChannelHost {
  int loginAttempts = 3;
  String id;
  String displayName;
  String secret;

  Channel clientChannel;
  GameServer server;
  Random random = Random();
  StreamController<String> messagesIn;

  initialise(GameServer server) async {

    this.server = server;

    clientChannel.listen((msg) => handleString(msg));
    messagesIn = await StreamController.broadcast();
  }



  requestLogin(){
    clientChannel.sink(Command.requestLogin);
  }

  handleString(String message) async{
    messagesIn.sink.add(message);

    String type = message.substring(0,3);
    String details = message.substring(3);

    switch(type){
      case Command.echo:
        send("echo $details");
        break;

      case Command.testData:
        await server.db.testData();
        send(Command.testData);
        break;

      case Command.login:

        String reply = '';

        List<String> _details = details.split(Command.delimiter);

        String id = _details[0];
        String password = _details[1];

        Record record = await server.db.getRecordWithId(id);

        if(record == null) {
          loginAttempts --;
          send(Command.gameError);
        } else if(password != record.password){
          loginAttempts --;
          send(Command.gameError);
        } else if(server.clientWithLogin(id)){
          server.removeClient(this);
          send(Command.gameError);
        }else {

          this.id = id;
          this.displayName = record.displayName;

          String secret = getSecret();

          reply += Command.loginSuccess;

          reply += secret;
          send(reply);
        }

        break;

      case Command.requestClientList:
        send(Command.requestClientList + server.clientList);
        break;

        default:
          send(Command.gameError);
          break;


    }


  }

  send(String message){
    clientChannel.sink(message);
  }

  String getSecret(){

    var rand = new Random();
    var codeUnits = new List.generate(
        16,
            (index){
          return rand.nextInt(33)+89;
        }
    );

    return new String.fromCharCodes(codeUnits);

  }


}