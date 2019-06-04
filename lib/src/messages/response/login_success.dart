




import 'package:game_server/src/messages/command/command.dart';
import 'package:game_server/src/messages/response/success.dart';

import '../message.dart';
import 'response.dart';

class LoginSuccess extends Success{

    static const String code = 'lgs';

    String playerId;
    String playerSecret;
    String displayName;

    LoginSuccess(this.playerId, this.playerSecret, this.displayName);

    LoginSuccess.fromString(String string){
        List<String> details = string.split((delimiter));

        playerId = details[0];
        playerSecret = details[1];
        displayName = details[2];
        }

    String get string => code + playerId + delimiter
        + playerSecret + delimiter
        + displayName;
}