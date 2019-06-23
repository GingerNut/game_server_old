part of server_connection;

class HttpConnection extends ServerConnection{

  HttpConnection(WebSocketChannel webSocket){
    clientChannel = WebChannelServer(this, webSocket);
  }


  }

