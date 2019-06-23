library channel;

import 'dart:async';

import 'package:game_server/src/messages/message.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'stream_channel.dart';
part 'web_channel_client_html.dart';
part 'web_channel_client_io.dart';
part 'web_channel_server.dart';

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

  handleJSON(String message);

  send(Message message);

  close();
}