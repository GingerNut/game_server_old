
import 'dart:io';

import 'package:game_server/src/channel/channel.dart';
import 'package:game_server/src/channel/web_channel_client_io.dart';
import 'package:game_server/src/client/web_client.dart';
import 'package:game_server/src/command/command.dart';
import 'package:game_server/src/user.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/io.dart';
import 'package:test/test.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'package:game_server/game_server.dart';

void main()async{

  String address = 'localhost';
  int port = 8080;

  IOWebChannelClient channel;

  User user;


  channel = IOWebChannelClient(user, "ws://" + address + ":$port");
  await channel.connect();


  setUp(() async {

    // dart C:\Users\Stephen\growing_games\game_server\bin\server.dart

  });


  test('websocket basics',() async{

    expect(await channel.first, Command.requestLogin);

    channel.sink(Command.echo + 'hey');
//    expect(await channel.firstWhere((s) => s.substring(0,3) == 'ech'), 'echo hey');

  });


  tearDown(() async {
   await channel.close();
  });



}