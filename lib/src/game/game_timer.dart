



import 'dart:async';
import 'package:quiver/async.dart' as quiver;
import 'package:game_server/src/game/player/player.dart';

class GameTimer{

  quiver.CountdownTimer countdownTimer;
  final Player player;
  final StreamController<TimeStamp> events = StreamController.broadcast();

  Duration get durationLeft => duration(_timeLeft);
  double get timeLeft => _timeLeft;

  Duration duration(double _time){
    int _seconds = _time.truncate();
    int _milliseconds = ((_time - _seconds)*1000).truncate();
    return Duration(seconds: _seconds, milliseconds: _milliseconds);
  }

  double get fraction => _timeLeft - _timeLeft.truncate();

  final double _totalTime;
  double _timeLeft;
  double _moveTime ;

  bool get ticking => countdownTimer != null ? countdownTimer.isRunning : false;

  TimeStamp get timeStamp => TimeStamp(_timeLeft);

  GameTimer(this. player, this._totalTime, {double moveTime = 0}){
    this._moveTime = moveTime;
    reset();
  }

  reset(){
    _timeLeft = _totalTime;
  }

  go() async{

    _timeLeft += _moveTime;

    countdownTimer = quiver.CountdownTimer(durationLeft, Duration(milliseconds: 100));

    countdownTimer.listen((e){
      _timeLeft = _timeLeft = countdownTimer.remaining.inMilliseconds / 1000;
      events.add(TimeStamp(_timeLeft));
    },

        onDone: (){
          _timeLeft = countdownTimer.remaining.inMilliseconds / 1000;

          events.add(TimeStamp(_timeLeft));
          countdownTimer.cancel();

          if(_timeLeft <= 0.0) player.outOfTime();

        });

  }

  stop(){
    _timeLeft = countdownTimer.remaining.inMilliseconds / 1000;
    countdownTimer.cancel();
  }

}

class CountdownTimer {
  CountdownTimer(Duration durationLeft, Duration duration);
}

class TimeStamp{

  final double timeLeft;
  String minutes = '';
  String seconds ='';
  String tenths  ='';
  String get display {

    if(timeLeft < 10) return seconds + '.' + tenths + 's';
    else if(timeLeft >= 60) return minutes + 'm ' + seconds + 's ';
    else {
      return seconds + 's ';
    }

  }

  TimeStamp(this. timeLeft){
    int _minutes = (timeLeft / 60) .truncate();
    int _seconds = (timeLeft - _minutes * 60).truncate();
    int _tenths = ((timeLeft - timeLeft.truncate())*10).truncate();

    minutes = _minutes.toString();
    seconds = _seconds.toString();
    tenths = _tenths.toString();
  }

}