



import '../message.dart';
import 'new_game.dart';

class JoinGame extends Message{
  static const String code = 'joi';
    String gameId;


  JoinGame(NewGame game){
    this.gameId = game.id;
  }

  JoinGame.fromString(String details){
    this.gameId = details;
  }

  String get string => code
      + gameId;
}