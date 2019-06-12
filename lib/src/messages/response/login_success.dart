


import 'dart:convert';
import 'package:game_server/src/messages/response/success.dart';

import '../message.dart';
import 'response.dart';

class LoginSuccess extends Success{
    static const String type = 'login_success';
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

    LoginSuccess.fromJSON(String string){

        var jsonObject = jsonDecode(string);

        playerId = jsonObject['player_id'];
        playerSecret = jsonObject['player_secret'];
        displayName = jsonObject['display_name'];
    }

    String get string {

        return code + playerId + delimiter
            + playerSecret + delimiter
            + displayName;
    }


    get json => jsonEncode({
            'type': type,
            'player_id': playerId,
            'display_name': displayName,
            'player_secret': playerSecret
        });


}