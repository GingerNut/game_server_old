library interface;


import 'dart:async';

import 'package:game_server/src/design/design.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game_server/advert_list.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/game_server.dart';


part 'http_interface.dart';
part 'local_http_interface.dart';
part 'local_interface.dart';
part 'stream_http_interface.dart';
part 'input.dart';

abstract class Interface{

  StreamController<Message> events = StreamController.broadcast();

  GameDependency dependency;

  Input input;

  Position position;

  Theme theme = Theme();

  Interface(this.dependency){
    input = dependency.getInput();
  }

  tryMove(Move move){
    position.makeMove(move);

    events.add(Success());

  }

}