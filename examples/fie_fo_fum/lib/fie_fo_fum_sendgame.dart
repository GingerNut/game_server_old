import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/messages/command/send_game.dart';

import 'fie_fo_fum_position.dart';

class FieFoFumSendGame extends SendGame{
  FieFoFumSendGame.fromGame(Game game) : super.fromGame(game);

  FieFoFumSendGame.fromString(String string){

   position = FieFoFumPosition();


  }



}