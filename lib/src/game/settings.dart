part of game;


class Settings{

  IntSetting maxPlayers = IntSetting(6);
  IntSetting playerType = IntSetting(Player.human);
  BoolSetting playerHelp = BoolSetting(false);
  BoolSetting randomStart = BoolSetting(true);

  BoolSetting timer = BoolSetting(true);
  DoubleSetting gameTime = DoubleSetting(300.0);
  DoubleSetting moveTime = DoubleSetting(12);
  StringSetting onlineGameName = StringSetting('New Game');

  String firstPlayer;

  get json => jsonEncode({
    'max_players': maxPlayers.string,
    'player_type' : playerType.string,
    'player_help' : playerHelp.string,
    'random_start' : randomStart.string,
    'timer': timer.string,
    'game_time' : gameTime.string,
    'move_time' : moveTime.string,
    'online_game' : onlineGameName.string,
  });

  Settings();

  Settings.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    maxPlayers = IntSetting(jsonObject['max_players']);
    playerType = IntSetting(jsonObject['player_type']);
    playerHelp = BoolSetting(jsonObject['player_help']);
    randomStart = BoolSetting(jsonObject['random_start']);
    timer = BoolSetting(jsonObject['timer']);
    gameTime = DoubleSetting(jsonObject['game_time']);
    moveTime = DoubleSetting(jsonObject['moveTime']);
    onlineGameName = StringSetting(jsonObject['online_game']);
  }


}





