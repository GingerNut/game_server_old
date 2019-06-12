abstract class Message{
  String delimiter = '\n';
  String internalDelimiter = ',';

  static String code;

  String get string;
  String get json;

//  Message.fromJSON(String string){
//
//    var jsonObject = JSON.jsonDecode(string);
//
//   ....
//  }

//  get json => JSON.jsonEncode({
//    'type': type,
//    ...
//  });



}