



import 'package:game_server/src/command/command.dart';

class Login extends Command{

  String playerId;
  String password;

  Login(this.playerId, this.password);



  String toString() {
      return Command.login + playerId + password;
  }



}