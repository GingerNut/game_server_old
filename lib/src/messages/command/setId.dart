import 'dart:convert';

import 'package:game_server/src/messages/response/echo_response.dart';

import '../message.dart';

class SetId extends Message{
  static const type = 'set_id';

  String text;

  SetId(this.text);

  SetId.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    text = jsonObject['text'];
  }

  get json => jsonEncode({
    'type': type,
    'text' : text
  });





}