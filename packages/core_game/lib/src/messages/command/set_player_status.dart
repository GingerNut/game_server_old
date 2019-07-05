part of message;

class SetStatus extends Message{
  static const type = 'set_player_status';

  PlayerStatus status;

  SetStatus(PlayerStatus status){
    this.status = status;
  }

  SetStatus.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    status = Position.playerStatusFromString(jsonObject['status']);
  }

  get json => jsonEncode({
    'type': type,

    'status' : Position.playerStatusToString(status)
  });

}

