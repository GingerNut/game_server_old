import 'dart:convert';

import '../message.dart';

class RequestPlayerList extends Message{
  static const type = 'request_players';
  static const code = 'rcl';


  RequestPlayerList();

  String get string => null;

  RequestPlayerList.fromJSON(String string){
    var jsonObject = jsonDecode(string);

  }

  get json => jsonEncode({
    'type': type,
  });





}