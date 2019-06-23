part of interface;


class StreamHttpInterface extends HttpInterface{

  final GameServer server;

  StreamHttpInterface(GameDependency injector, this.server) : super(injector);

  Future login(String id, String password) async{
    super.login(id, password);
    connection = await StreamClientConnection(this, server);

    await connection.login(id, password);
    return;
  }





}