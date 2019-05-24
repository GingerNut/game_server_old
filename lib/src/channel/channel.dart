

abstract class Channel{
  final ChannelHost host;

  Channel(this.host);

  Future<dynamic> first;

  listen(Function func);

  sink(String string);

  Future<dynamic> firstWhere(Function func);

  close();

}

mixin ChannelHost{

  handleString(String message);

}