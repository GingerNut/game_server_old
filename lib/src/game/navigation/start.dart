part of game;

class StartingPosition extends GameEvent{
  static const String type = 'starting_position';

  StartingPosition(String string){

    resultingPosition = string;
    number = 0;
  }

  String get string => resultingPosition;

}