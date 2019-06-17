import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/game/settings.dart';

class ChessSettings extends Settings{

  int maxPlayers = 2;
  int playerType = Player.human;
  bool playerHelp = true;
  bool randomStart = false;

  bool timer = true;
  double gameTime = 300.0;
  double moveTime = 12;
  String onlineGameName = 'Chess Game';

}