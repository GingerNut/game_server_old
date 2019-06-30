part of game;

class LocalPlayer extends Player{

  final LocalInterface ui;

  LocalPlayer(this.ui);

  go(){
    print('here');
    ui.events.add(GameTimer.start(game.position));
  }

  stop(){
    ui.events.add(GameTimer.stop(game.position));
  }
}