

abstract class Channel{
  final ChannelHost host;

  Channel(this.host);

  Future<String> first;

  listen(Function func);

  sink(String string);

}

mixin ChannelHost{

message(String message);

}