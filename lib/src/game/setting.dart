part of game;


abstract class Setting<T>{

  String name;

  T _value;

  get value => _value;

  set value (T v) => _value = v;
}


class IntSetting extends Setting<int>{

  IntSetting(int value){
    _value = value;
  }


  String get json => jsonEncode({
      'name' : name,
      'value' : _value
  });

  IntSetting.fromJSON(String string){
    var jsonObject = jsonDecode(string);
    name = jsonObject['name'];
    _value = jsonObject['value'];

  }

}

class DoubleSetting extends Setting<double> {

  DoubleSetting(double value) {
    _value = value;
  }

  String get json =>
      jsonEncode({
        'name': name,
        'value': _value
      });

  DoubleSetting.fromJSON(String string){
    var jsonObject = jsonDecode(string);
    name = jsonObject['name'];
    _value = jsonObject['value'];
  }
}

class BoolSetting extends Setting<bool> {

  BoolSetting(bool value) {
    _value = value;
  }

  String get json =>
      jsonEncode({
        'name': name,
        'value': _value == true ? 'TRUE' : 'FALSE',
      });

  BoolSetting.fromJSON(String string){
    var jsonObject = jsonDecode(string);
    name = jsonObject['name'];
    _value = jsonObject['value'] == 'TRUE' ? true : false;
  }
}

class StringSetting extends Setting<String>{
  StringSetting(String value){
    _value = value;
  }

  String get json =>
      jsonEncode({
        'name': name,
        'value': _value
      });

  StringSetting.fromJSON(String string){
    var jsonObject = jsonDecode(string);
    name = jsonObject['name'];
    _value = jsonObject['value'];
  }


}