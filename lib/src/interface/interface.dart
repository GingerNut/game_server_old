library interface;


import 'package:game_server/src/design/color_scheme.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game_server/advert_list.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/game_server.dart';

import 'package:game_server/src/game_dependency.dart';

part 'http_interface.dart';
part 'local_http_interface.dart';
part 'local_interface.dart';
part 'stream_http_interface.dart';

abstract class Interface{

  GameDependency dependency;

  Position position;

  ColorScheme colorScheme;

  Interface(this.dependency);




}