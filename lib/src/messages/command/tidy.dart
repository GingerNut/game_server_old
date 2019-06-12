import 'dart:convert';

import '../message.dart';

class Tidy extends Message{
  static const String type = 'tidy';


  Tidy();


Tidy.fromJSON(String string){
  var jsonObject = jsonDecode(string);
}

get json => jsonEncode({
  'type': type,
});

}