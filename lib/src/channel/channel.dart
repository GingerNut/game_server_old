

abstract class Channel{
  final ChannelHost host;

  Channel(this.host);

  Future<dynamic> first;

  listen(Function func);

  sink(String string);

}

mixin ChannelHost{

  handleString(String message);

}