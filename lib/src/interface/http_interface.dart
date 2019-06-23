part of interface;

class HttpInterface extends Interface{


  String id = 'Player';
  String password = '';

  HttpInterface(GameDependency dependency) : super(dependency);
  ClientConnection connection;
  PlayerStatus _status;
  AdvertList adverts = new AdvertList();
  List<ChatMessage> chatMessages = List();
  List<PrivateMessage> privateMessages = List();

  login(String id, String password){
    this.id = id;
    this.password = password;
  }

  logout(){
    connection.send(Logout(id));
    connection.close();
  }

  advertiseGame()=> connection.send(NewGame.fromSettings(dependency.settings));

  joinGame(NewGame game)=> connection.send(JoinGame(game));

  startGame(NewGame game)=> connection.send(StartGame(game));

  setPosition(SendPosition sendPosition) {
    position = sendPosition.build(dependency.getPositionBuilder());
  }

  set status (PlayerStatus status) {
    bool changed = false;

    if(_status != status) changed = true;

    _status = status;

    if (changed) connection.send(SetStatus(status));
  }

  doMove(MakeMove makeMove){
    Move move = makeMove.build(dependency.getMoveBuilder());
    position.makeMove(move);
  }

  PlayerStatus get status => _status;

  sendChat(String text) async => connection.send(ChatMessage(id, text));

  sendMessage(String to, String text) => connection.send(PrivateMessage(id, to, text));


}