import 'dart:async';

import 'channel.dart';




class StreamChannel extends Channel{
  StreamChannel otherEnd;

  StreamController messagesOut = StreamController<String>();

  StreamChannel(ChannelHost host) : super(host);

  static handshake(StreamChannel one, StreamChannel two){
    one.otherEnd = two;
    two.otherEnd = one;

  }


  Future<String> get first => otherEnd.messagesOut.stream.first;

  listen(Function func) => otherEnd.messagesOut.stream.listen(func);

  @override
  sink(String string) {
   messagesOut.add(string);
  }





}