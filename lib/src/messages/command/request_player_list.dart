import 'dart:convert';

import '../message.dart';

class RequestPlayerList extends Message{
  static const type = 'request_players';



  RequestPlayerList();


  RequestPlayerList.fromJSON(String string){
    var jsonObject = jsonDecode(string);

  }

  get json => jsonEncode({
    'type': type,
  });





}