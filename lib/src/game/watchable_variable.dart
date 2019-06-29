part of game;

class Watchable<T>{

  Watchable(this._value);

  Watchable.fromString(String string){
    if(_value is int){
      _value = int.parse(string) as T;
    } else if(_value is double){
      _value = double.parse(string) as T;
    } if(_value is bool){
      _value = string == 'TRUE' ? true as T : false as T;
    }

  }

  T _value;

  get value => _value;

  set (T value) => _value = value;

  String get string{

    switch(T.runtimeType){

      case int: return _value.toString();

      case double: return _value.toString();

      case bool: return _value == true ? 'TRUE' : 'FALSE';

    }

  }

}