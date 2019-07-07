




import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/messages/game_message/game_message.dart';

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