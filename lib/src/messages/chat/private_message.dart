part of message;


class PrivateMessage extends Message{
  static const String type = 'private_message';
  static const String code = 'pri';

  String from;
  String to;
  DateTime  timeStamp;
  String text;

  PrivateMessage(this.from, this.to, this.text);

  PrivateMessage.fromString(String string){
    List<String> details = string.split(Message.delimiter);

    from = details[0];
    to = details[1];
    text = details[2];
    timeStamp = DateTime.now();
  }

  String get string => code
      + from + Message.delimiter
      + to + Message.delimiter
      + text;

  PrivateMessage.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    from = jsonObject['from'];
    to = jsonObject['to'];
    text = jsonObject['text'];
  }

  get json => jsonEncode({
    'type': type,
    'text' : text,
    'from':from,
    'to':to
  });


}