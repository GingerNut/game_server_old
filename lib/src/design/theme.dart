part of design;

class Theme{
  GameColor get background => GameColor.fromString('#006400');
  GameColor get highlight => GameColor.fromString('#8FBC8F');
  GameColor get button => GameColor(0xFF4CAF50);
  GameColor get buttonShadow => GameColor(0xFF4CAF50);

  GameColor get lightText => GameColor(0xFFFFFFFF);
  GameColor get darkText => GameColor(0x00000000);

  GameColor get tileLight => GameColor(0xFFFFECB3);
  GameColor get tileDetail => GameColor(0xFFFF6F00);
  GameColor get tileDark => GameColor(0xFF795548);
  GameColor get tileHighLight => GameColor(0xffffffff);

  GameColor get go => GameColor(0xFF4CAF50);
  GameColor get stop => GameColor(0xFFF44336);
  GameColor get wait => GameColor(0xFFFFC107);

  GameColor get noPlayer => GameColor(0XFF9E9E9E);
  List<GameColor> get defaultPlayerColors => [
    GameColor(0xFF3F51B5),
    GameColor(0xFFF44336),
    GameColor(0xFFF44336),
    GameColor(0xFFF44336),
  ];




}