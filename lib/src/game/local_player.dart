part of game;


class LocalPlayer extends Player{

  final LocalInterface ui;

  LocalPlayer(this.ui);

  go(){
  }

  stop(){
    ui.events.add(GameTimer.stop(game.position));
  }
}