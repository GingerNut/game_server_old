import 'dart:async';
import 'dart:math';

import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/messages/chat/chat_message.dart';
import 'package:game_server/src/game_server/channel/channel.dart';
import 'package:game_server/src/messages/chat/private_message.dart';
import 'package:game_server/src/messages/command/command.dart';
import 'package:game_server/src/game_server/database/record.dart';
import 'package:game_server/src/messages/command/join_game.dart';
import 'package:game_server/src/messages/command/login.dart';
import 'package:game_server/src/messages/command/new_game.dart';
import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/command/start_game.dart';
import 'package:game_server/src/messages/error/game_error.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/login_success.dart';

import '../../../game_server.dart';



class ServerConnection implements ChannelHost {

  Player player;

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
    messagesIn = await StreamController();
  }

  close(){
    clientChannel.close();
  }

  requestLogin(){
    send(Command.requestLogin);
  }

  handleString(String message) async{
    messagesIn.sink.add(message);

    String type = message.substring(0,3);
    String details = message.substring(3);

    switch(type){
      case Command.echo:
        send("echo $details");
        break;

      case Login.code:

        String reply = '';

        var login = Login.fromString(details);

        Record record = await server.db.getRecordWithId(login.playerId);

        if(record == null) {
          loginAttempts --;
          send(GameError('player not found').string);
        } else if(login.password != record.password){

          loginAttempts --;
          send(GameError('password incorrect').string);
        } else if(server.clientWithLogin(login.playerId)){

          server.removeConnection(this);
          send(GameError('already logged in').string);

        } else {

          this.id = login.playerId;
          this.displayName = record.displayName;

          var logSuccess = LoginSuccess(id, _getSecret(), displayName);
          send(logSuccess.string);
        }
        break;

      case Command.requestClientList:
        send(Command.requestClientList + server.playersOnlineList);
        break;

      case LoginSuccess.code:
        server.addMember(this);
        break;

      case Command.logout:
        server.removeConnection(this);
        server.removeMember(this);
        break;


      case ChatMessage.code:
        ChatMessage msg = ChatMessage.fromString(details);
        server.addGeneralChat(msg);
        break;

      case PrivateMessage.code:
        PrivateMessage msg = PrivateMessage.fromString(details);
        server.addPrivateMessage(msg);
        break;

      case NewGame.code:
        NewGame advert = NewGame.fromString(details);
        server.advertiseGame(advert);
        break;

      case JoinGame.code:
        var join = JoinGame.fromString(details);
        Message response = await server.joinGame(player, join.gameId);
        send(response.string);
        break;

      case StartGame.code:
        var start = StartGame.fromString(details);
        Message response = await server.startGame(start.gameId);
        send(response.string);
        break;

      case SetStatus.code:
        player.status = SetStatus.fromString(details).status;
        break;

        default:
          send(GameError('unknown command').string);
          break;

    }
  }

  send(String message){
    clientChannel.sink(message);
  }

  String _getSecret(){

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