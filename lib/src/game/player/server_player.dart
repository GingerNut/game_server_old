part of player;




class ServerPlayer extends Player{

  ServerConnection connection;

  ServerPlayer(String id){
    this.id = id;
  }

  set status (PlayerStatus newStatus) {
    bool changed = false;

    if(status != newStatus) changed = true;

    game.position.playerStatus[id] = newStatus;

    if (changed && connection != null) connection.send(SetStatus(newStatus).string);
  }

  yourTurn(){
    if(connection != null) connection.send(YourTurn(gameId).string);
  }

}