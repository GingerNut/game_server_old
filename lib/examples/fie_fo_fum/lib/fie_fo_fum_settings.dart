import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/game/settings.dart';

class FieFoFumSettings extends Settings{

  int maxPlayers = 4;
  int playerType = Player.human;
  bool playerHelp = false;
  bool randomStart = false;

  bool timer = true;
  double gameTime = 5.0;
  double moveTime = 3.0;
  String onlineGameName = 'Fie Fo Fum Game';













}