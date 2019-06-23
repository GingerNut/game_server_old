part of channel;

class WebChannelServer extends Channel{
  WebChannelServer(ChannelHost host, this.socketChannel) : super(host);

  final WebSocketChannel socketChannel;

  @override
  listen(Function func) => socketChannel.stream.listen(func);

  @override
  sink(String string)=> socketChannel.sink.add(string);


  Future<dynamic> firstWhere(Function func) => socketChannel.stream.firstWhere(func);

  close(){}

}