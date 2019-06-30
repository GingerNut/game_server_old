part of interface;

class LocalInterface extends Interface{

//TODO local games server. Only one login allowed but that stays in background

//pass and play

Settings localSettings;
Game game;
NewGame newGame;


getGame(NewGame newGame) => dependency.getGame(newGame);


Position get position => game.position;

LocalInterface(GameDependency injector) : super(injector){
  localSettings = dependency.settings;
  resetGame();
}

resetGame(){
  newGame = NewGame.local(localSettings);
}

addPlayer(Player player) => newGame.addLocalPlayer(player);

startLocalGame()async{
  game = getGame(newGame);
  await game.initialise();
}

tryMove(Move move) {
  game.makeMove(move, game.gameId, game.position.playerId);
  events.add(RefreshScreen());
}




}