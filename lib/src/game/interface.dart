part of game;



abstract class Interface{

  StreamController<GameMessage> events = StreamController.broadcast();

  GameDependency dependency;

  Input input;

  Position position;

  String playerId;

  Theme theme = Theme();

  Interface(this.dependency){
    input = dependency.getInput(this);
  }

  tryMove(Move move);

}