import 'dart:math';

import 'package:game_server/src/channel/channel.dart';
import 'package:game_server/src/command/command.dart';

import '../../game_server.dart';

class Client implements ChannelHost {
  Channel userChannel;
  GameServer server;
  Random random = Random();

  initialise(GameServer server) {

    this.server = server;

    userChannel.listen((msg) => handleString(msg));
  }

  requestLogin(){
    userChannel.sink(Command.requestLogin);
  }

  handleString(String message) async{
    print('client string ' + message);

    String type = message.substring(0,3);
    String details = message.substring(3);

    switch(type){
      case Command.echo:
        userChannel.sink("echo $details");
        break;

      case Command.login:

        String reply = '';

        List<String> _details = details.split(Command.delimiter);

        String id = _details[0];
        String password = _details[1];

        if((await server.db.getRecordWithId(id)).password != password) reply += Command.gameError;

        else {

          String secret = getSecret();

          reply += Command.loginSuccess;

          reply += secret;
        }

        userChannel.sink(reply);

        break;



    }


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