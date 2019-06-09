




import 'package:game_server/src/game/player/player.dart';

class Settings{

  int numberOfPlayers = 4;
  static const int maxPlayers = 6;
  int playerType = Player.human;
  bool playerHelp = false;
  bool randomStart = true;

   bool timer = true;
  double gameTime = 300.0;
  double moveTime = 12;
  String onlineGameName = 'New Game';



  String get string {
    String string = '';

    string += numberOfPlayers.toString();
    string += '\n';

    string += playerType.toString();
    string += '\n';

    string += timer.toString();
    string += '\n';

    string += gameTime.toString();
    string += '\n';

    string += moveTime.toString();
    string += '\n';

    return string;

  }

  Settings();

  Settings.fromString(String string){

    List<String> settingsList = string.split('\n');

    numberOfPlayers = int.parse(settingsList[0]);

    playerType = int.parse(settingsList[1]);

    timer = settingsList[2] == true.toString();

    gameTime = double.parse(settingsList[3]);

    moveTime = double.parse(settingsList[4]);

  }


}





