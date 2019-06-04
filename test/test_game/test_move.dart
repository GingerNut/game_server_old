

import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/messages/response/success.dart';

import 'test_position.dart';

abstract class TestMove extends Move<TestPosition>{

  doCheck(TestPosition position) => Success();

  doMove(TestPosition position);

}

