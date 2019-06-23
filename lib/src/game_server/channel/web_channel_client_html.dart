part of channel;

class HMTLWebChannelClient extends Channel{
  HMTLWebChannelClient(ChannelHost host) : super(host);

  @override
  listen(Function func) {}

  Future<dynamic> firstWhere(Function func){}

  close(){}


  @override
  sink(String string) {

  }

}