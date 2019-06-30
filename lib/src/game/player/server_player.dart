part of game;




class ServerPlayer extends Player{

  ServerConnection connection;

  ServerPlayer(String id){
    this.id = id;
  }

  set status (PlayerStatus newStatus) {
    bool changed = false;

    if(status != newStatus) changed = true;

    game.position.playerStatus[id] = newStatus;

    if (changed && connection != null) connection.send(SetStatus(newStatus));
  }

  moveUpdate(MakeMove move){
    connection.send(move);
  }

  gameStarted(String gameId) => connection.send(GameStarted(gameId));

  go(){
    if(connection != null) connection.send(YourTurn(gameId));
  }

  stop(){}

}