part of message;

class LoginSuccess extends Success{
    static const String type = 'login_success';

    String playerId;
    String playerSecret;
    String displayName;

    LoginSuccess(this.playerId, this.playerSecret, this.displayName);


    LoginSuccess.fromJSON(String string){

        var jsonObject = jsonDecode(string);

        playerId = jsonObject['player_id'];
        playerSecret = jsonObject['player_secret'];
        displayName = jsonObject['display_name'];
    }



    get json => jsonEncode({
            'type': type,
            'player_id': playerId,
            'display_name': displayName,
            'player_secret': playerSecret
        });


}