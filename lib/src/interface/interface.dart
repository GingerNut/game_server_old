

import 'dart:async';

import '../../game.dart';
import '../../game_message.dart';
import 'input.dart';

abstract class Interface{

  StreamController<GameMessage> events = StreamController.broadcast();

  GameDependency dependency;

  Input input;

  Position position;

  Theme theme = Theme();

  Interface(this.dependency){
    input = dependency.getInput(this);
  }

  tryMove(Move move);

}