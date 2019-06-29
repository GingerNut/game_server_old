part of game;

abstract class Setting<T>{

  T _value;

  get value => _value;

  set value (T v) => _value = v;
}


class IntSetting extends Setting<int>{

  IntSetting(int value){
    _value = value;
  }

  String get string => _value.toString();

  IntSetting.fromString(String string){
    _value = int.parse(string);
  }

}

class DoubleSetting extends Setting<double>{

  DoubleSetting(double value){
    _value = value;
  }

  String get string => _value.toString();

  DoubleSetting.fromString(String string){
    _value = double.parse(string);
  }

}

class BoolSetting extends Setting<bool>{

  BoolSetting(bool value){
    _value = value;
  }

  String get string => _value == true ? 'TRUE' : 'FALSE';

  BoolSetting.fromString(String string){
    _value = string == 'TRUE' ? true : false;
  }
}