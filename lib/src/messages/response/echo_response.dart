part of message;

class EchoResponse extends Message{
  static const type = 'echo_response';

  String text;

  EchoResponse(this.text);

  EchoResponse.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    text = jsonObject['text'];
  }

  get json => jsonEncode({
    'type': type,
    'text' : text
  });





}