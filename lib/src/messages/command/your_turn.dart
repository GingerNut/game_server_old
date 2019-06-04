


import '../message.dart';
import 'new_game.dart';

class YourTurn extends Message{
  static const String code = 'you';
  String gameId;

  YourTurn(this.gameId);

  YourTurn.fromString(String details){
    this.gameId = details;
  }

  String get string => code
      + gameId;
}