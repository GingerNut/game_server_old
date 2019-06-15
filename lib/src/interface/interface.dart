import 'package:game_server/src/design/color_scheme.dart';
import 'package:game_server/src/game/position.dart';

import '../injector.dart';

abstract class Interface{

  Injector injector;

  Position position;

  ColorScheme colorScheme;

  Interface(this.injector);




}