part of game;

class LocalPlayer extends Player{

  final LocalInterface ui;

  LocalPlayer(this.ui);

  go(){
    ui.events.sink.add(GameTimer.start(game.position));
  }

  stop(){
    ui.events.sink.add(GameTimer.stop(game.position));
  }
}