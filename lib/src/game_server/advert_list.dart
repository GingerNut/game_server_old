part of game_server;


class AdvertList{

  List<NewGame> _adverts = new List();

  operator [](int i) => _adverts[i];
  operator []=(int i, NewGame value) => _adverts[i] = value;

  add(NewGame advert) => _adverts.add(advert);

  remove(NewGame advert) => _adverts.remove(advert);

  int get length => _adverts.length;

  int get hash {

    int hash = 0;

    _adverts.forEach((a) => hash += a.hash);

    return hash;

  }

  NewGame getAdvertrWithId(String id){

    NewGame game;

    _adverts.forEach((a) {
      if(a.id == id) game = a;
    });

    return game;

  }





}