part of fie_fo_fum;

class FieFoFumSettings extends Settings{

  IntSetting maxPlayers = IntSetting(4);
  IntSetting playerType = IntSetting(Player.human);
  BoolSetting playerHelp = BoolSetting(false);
  BoolSetting randomStart = BoolSetting(false);

  BoolSetting timer = BoolSetting(true);
  DoubleSetting gameTime = DoubleSetting(5.0);
  DoubleSetting moveTime = DoubleSetting(3);
  StringSetting onlineGameName = StringSetting('Fie Fo Fum Game');


}