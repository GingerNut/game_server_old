part of message;


class Echo extends Message{
  static const type = 'echo';

  String text;

  Echo(this.text);

  EchoResponse get response => EchoResponse('echo ' + text);

  Echo.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    text = jsonObject['text'];
  }

  get json => jsonEncode({
    'type': type,
    'text' : text
  });





}