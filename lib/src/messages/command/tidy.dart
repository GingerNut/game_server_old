part of message;

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