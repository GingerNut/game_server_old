import 'game_dependency.dart';

class Injector{
  static final Injector _singleton = Injector._internal();

  static GameDependency _gameDependency;

  static void configure(GameDependency dependency){
    _gameDependency = dependency;
  }

  factory Injector(){
    return _singleton;
  }

  Injector._internal();

  GameDependency get gameDependency => _gameDependency;
}