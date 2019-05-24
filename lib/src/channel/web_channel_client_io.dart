

import 'package:web_socket_channel/io.dart';

import 'channel.dart';


class IOWebChannelClient extends Channel{
  IOWebSocketChannel webSocketChannel;
  final String address;

  IOWebChannelClient(ChannelHost host, this.address) : super(host);



  Future<void> connect()async{
    webSocketChannel = await IOWebSocketChannel.connect(address);
    return;
  }

  Future<dynamic> get first => webSocketChannel.stream.first;

  Future<dynamic> firstWhere(Function func) => webSocketChannel.stream.firstWhere(func);

  close(){}

  listen(Function func) => webSocketChannel.stream.listen(func);

  @override
  sink(String string) => webSocketChannel.sink.add(string);


}