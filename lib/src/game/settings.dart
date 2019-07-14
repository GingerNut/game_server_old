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

  IntSetting aiDepth = IntSetting(3);
  DoubleSetting thinkingTime = DoubleSetting(5);

  String firstPlayer;

  get json => jsonEncode({
    'max_players': maxPlayers.json,
    'player_type' : playerType.json,
    'player_help' : playerHelp.json,
    'random_start' : randomStart.json,
    'timer': timer.json,
    'game_time' : gameTime.json,
    'move_time' : moveTime.json,
    'online_game' : onlineGameName.json,
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





