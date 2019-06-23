part of interface;

class LocalInterface extends Interface{

//TODO local games server. Only one login allowed but that stays in background

//pass and play

Settings localSettings = Settings();
Game game;
NewGame newGame;

getGame(NewGame newGame) => dependency.getGame(newGame);



Position get position => game.position;

LocalInterface(GameDependency injector) : super(injector){
  resetGame();
}

resetGame(){
  newGame = NewGame.local(dependency.settings);
}

addPlayer(Player player) => newGame.addLocalPlayer(player);

startGame(NewGame newgame)async{
  game = getGame(newgame);
  await game.initialise();
}

makeMove(Move move) => game.makeMove(move, game.gameId, game.position.playerId);





}