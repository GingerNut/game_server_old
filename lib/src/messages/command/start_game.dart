


import 'new_game.dart';

class StartGame {
  static const String code = 'sta';
  String gameId;

  StartGame(NewGame game){
    this.gameId = game.id;
  }

  StartGame.fromString(String details){
    this.gameId = details;
  }

  String get string => code
      + gameId;
}