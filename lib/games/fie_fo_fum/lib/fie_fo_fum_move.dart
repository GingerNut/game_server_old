part of fie_fo_fum;


abstract class FieFoFumMove extends Move<FieFoFumPosition>{

  doCheck(FieFoFumPosition position) => Success();

  doMove(FieFoFumPosition position);

}

