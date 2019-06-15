import 'package:game_server/src/design/color_scheme.dart';
import 'package:game_server/src/game/position.dart';

import '../game_dependency.dart';

abstract class Interface{

  GameDependency injector;

  Position position;

  ColorScheme colorScheme;

  Interface(this.injector);




}