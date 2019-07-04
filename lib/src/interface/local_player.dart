


import 'package:core_game/html_game.dart';
import 'package:core_game/src/messages/game_message/game_message.dart';

import 'local_interface.dart';

class LocalPlayer extends Player{

  final LocalInterface ui;

  LocalPlayer(this.ui);

  go(){
    ui.events.add(GameTimer.start(game.position));
  }

  stop(){
    ui.events.add(GameTimer.stop(game.position));
  }
}