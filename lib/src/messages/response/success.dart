part of message;

class Success extends Message{
  static const String type = 'success';

  String text = '';

  bool operator ==(other) => other is Success;

  Success();



  Success.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    text = jsonObject['text'];
  }

  get json => jsonEncode({
    'type': type,
    'text' : text
  });
}