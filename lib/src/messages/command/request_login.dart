import 'dart:convert';

import '../message.dart';

class RequestLogin extends Message{
  static const type = 'request_login';

  RequestLogin();


  RequestLogin.fromJSON(String string){
    var jsonObject = jsonDecode(string);

  }

  get json => jsonEncode({
    'type': type,

  });





}