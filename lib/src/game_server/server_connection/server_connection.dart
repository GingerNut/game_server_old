import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/messages/chat/chat_message.dart';
import 'package:game_server/src/game_server/channel/channel.dart';
import 'package:game_server/src/messages/chat/private_message.dart';
import 'package:game_server/src/game_server/database/record.dart';
import 'package:game_server/src/messages/command/echo.dart';
import 'package:game_server/src/messages/command/join_game.dart';
import 'package:game_server/src/messages/command/login.dart';
import 'package:game_server/src/messages/command/logout.dart';
import 'package:game_server/src/messages/command/new_game.dart';
import 'package:game_server/src/messages/command/request_login.dart';
import 'package:game_server/src/messages/command/request_player_list.dart';
import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/command/start_game.dart';
import 'package:game_server/src/messages/error/game_error.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/echo_response.dart';
import 'package:game_server/src/messages/response/login_success.dart';
import 'package:game_server/src/messages/response/player_list.dart';
import 'package:game_server/src/messages/response/success.dart';

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
    clientChannel.listen((msg) => handleJSON(msg));
    messagesIn = await StreamController();
  }

  close(){
    clientChannel.close();
  }

  requestLogin(){
    send(RequestLogin());
  }

  handleJSON(String string) async{

    var message = Message.inflate(string);

    messagesIn.sink.add(string);

    switch(message.runtimeType){

      case Echo:
        send(EchoResponse(string));
        break;

      case Login:

        var login = message as Login;

        Record record = await server.db.getRecordWithId(login.playerId);

        if(record == null) {
          loginAttempts --;
          send(GameError('player not found'));
        } else if(login.password != record.password){

          loginAttempts --;
          send(GameError('password incorrect'));
        } else if(server.clientWithLogin(login.playerId)){

          server.removeConnection(this);
          send(GameError('already logged in'));

        } else {

          this.id = login.playerId;
          this.displayName = record.displayName;

          var logSuccess = LoginSuccess(id, _getSecret(), displayName);
          send(logSuccess);
        }
        break;

      case RequestPlayerList:

        send(PlayerList(server.playersOnlineList));
        break;

      case LoginSuccess:
        server.addMember(this);
        break;

      case Logout:
        server.removeConnection(this);
        server.removeMember(this);
        break;


      case ChatMessage:
        ChatMessage msg = message as ChatMessage;
        server.addGeneralChat(msg);
        break;

      case PrivateMessage:
        PrivateMessage msg = message as PrivateMessage;
        server.addPrivateMessage(msg);
        break;

      case NewGame:
        NewGame advert = message as NewGame;
        server.advertiseGame(advert);
        break;

      case JoinGame:
        var join = message  as JoinGame;
        Success response = await server.joinGame(player, join.gameId);
        send(response);
        break;

      case StartGame:
        var start = message as StartGame;
        Success response = await server.startGame(start.gameId);
        send(response);
        break;

      case SetStatus:
        var setstatus = message as SetStatus;
        player.status = setstatus.status;
        break;

      default:
        send(GameError('unknown command'));
        break;


    }

  }


  send(Message message){
    clientChannel.sink(message.json);
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