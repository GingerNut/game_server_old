import 'dart:convert';

import '../message.dart';

class RequestLogin extends Message{
  static const type = 'request_login';
  static const code = 'rql';


  RequestLogin();

  String get string => code;

  RequestLogin.fromJSON(String string){
    var jsonObject = jsonDecode(string);

  }

  get json => jsonEncode({
    'type': type,

  });





}