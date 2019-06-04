import 'package:game_server/src/messages/command/new_game.dart';

class AdvertList{

  List<NewGame> _adverts = new List();

  add(NewGame advert) => _adverts.add(advert);
  int get length => _adverts.length;

  int get hash {

    int hash = 0;

    _adverts.forEach((a) => hash += a.hash);

    return hash;

  }





}