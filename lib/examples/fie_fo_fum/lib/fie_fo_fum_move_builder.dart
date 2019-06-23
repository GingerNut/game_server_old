part of fie_fo_fum;

class FieFoFumMoveBuilder extends MoveBuilder{

  build(String string) {

    switch(string){
      case 'fie' : return MoveFie();
      case 'fo' : return MoveFo();
      case 'fum' : return MoveFum();
      case 'num' : return MoveNumber();
    }
    return null;
  }

}



