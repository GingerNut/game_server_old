library server_connection;

import 'dart:async';
import 'dart:math';

import 'package:game_server/game_server.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game_server/channel/channel.dart';
import 'package:game_server/src/game_server/database/database.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';




part 'http_connection.dart';
part 'stream_connection.dart';


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

      case MakeMove:
        MakeMove makeMove = message as MakeMove;
        server.requestMove(makeMove);
        break;

      case ConfirmMove:
        ConfirmMove confirm = message as ConfirmMove;
        server.confirmMove(confirm);
        break;

      case GameError:
        var error = message as GameError;
        print (error.text);
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

    var rand = Random();
    var codeUnits = List.generate(
        16,
            (index){
          return rand.nextInt(33)+89;
        }
    );

    return String.fromCharCodes(codeUnits);
  }


}