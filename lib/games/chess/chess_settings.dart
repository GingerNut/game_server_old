part of chess;

class ChessSettings extends Settings{

  IntSetting maxPlayers = IntSetting(2);
  IntSetting playerType = IntSetting(Player.human);
  BoolSetting playerHelp = BoolSetting(false);
  BoolSetting randomStart = BoolSetting(true);

  BoolSetting timer = BoolSetting(true);
  DoubleSetting gameTime = DoubleSetting(300.0);
  DoubleSetting moveTime = DoubleSetting(12);
  StringSetting onlineGameName = StringSetting('New Chess Game');


}