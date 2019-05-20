

import 'package:web_socket_channel/io.dart';

import 'channel.dart';


class IOWebChannelClient extends Channel{
  IOWebSocketChannel webSocketChannel;

  IOWebChannelClient(ChannelHost host) : super(host);



  connect(String address, int port)async{
    webSocketChannel = await IOWebSocketChannel.connect("ws://" + address + ":$port");
  }

  Future<String> get first => webSocketChannel.stream.first;

  listen(Function func) => webSocketChannel.stream.listen(func);

  @override
  sink(String string) => webSocketChannel.sink.add(string);


}