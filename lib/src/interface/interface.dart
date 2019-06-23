import 'package:game_server/src/design/color_scheme.dart';
import 'package:game_server/src/game/game.dart';


import '../game_dependency.dart';

abstract class Interface{

  GameDependency dependency;

  Position position;

  ColorScheme colorScheme;

  Interface(this.dependency);




}