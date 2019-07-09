part of fie_fo_fum;

class FieFoFumPosition extends Position{

  int count;

  get playerOrder => PlayerOrder.sequential;
  get dependency => FieFoFumInjector();

  get externalVariablesString => count.toString();

  initialiseExternalVariables() => count = 1;

  setExternalVariables(String string)=> count = int.parse(string);

  analyse() {}

  setUpNewPosition() => count ++;

  bool canPlay(String id) => (id == playerId);

  List<Move> getPossibleMoves() => [MoveNumber(), MoveFie(), MoveFo(), MoveFum()];

  double value(String playerId) {
    double value = score[playerId];

    if(playerStatus[playerId] == PlayerStatus.out) value -= 100;

    return value;
  }

}