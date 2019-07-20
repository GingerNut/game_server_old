
import 'dart:async';
import 'dart:math';
import 'package:game_server/game_server.dart' as prefix0;
import 'package:game_server/games/chess/chess.dart';
import 'package:game_server/game_server.dart';
import 'package:game_server/src/design/design.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/interface/local_http_interface.dart';
import 'package:game_server/src/interface/stream_http_interface.dart';
import 'package:game_server/src/messages/game_message/game_message.dart';
import 'package:game_server/src/messages/message.dart';


import 'package:test/test.dart';
import 'package:test/test.dart' as prefix1;

import 'dummy_position.dart';


void main()async{

  Future <T> next<T>(Stream<T> stream )async{

    await for(T message in stream){
      return message;
    }
  }

  group('notation', (){

    test('chess notation', (){

      LocalInterface ui = LocalInterface(ChessInjector());

      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      ui.startLocalGame();

      ChessPosition position = ui.game.position;

      Tiles tiles = position.tiles;

      expect(tiles.tile(0,0).label, 'a1');
      expect(tiles.tile(3,1).label, 'b4');
      expect(tiles.tile(5,3).label, 'd6');
      expect(tiles.tile(7,7).label, 'h8');
    });


  });

  group('tiles functions',(){
    
    ChessPosition position;
    
    setUp((){

      LocalInterface ui = LocalInterface(ChessInjector());

      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      ui.startLocalGame();

      position = ui.game.position;
      
    });

    test('all directions square',(){

      var tiles = Tiles.squareTiles(8, ConnectionScheme.allDirections);

      expect(tiles.tiles.length, 64);


    });

    test('pieces getting teken',(){

      position.clearPieces();

      expect(position.tiles.tiles.length, 64);

      Pawn pawn = Pawn(position.tiles);

      Tile tile = position.tiles.tile(0, 0);
      pawn.tile = tile;
      pawn.setup();

      expect(pawn.tile, position.tiles.tile(0,0));
      Pawn second = Pawn(position.tiles);
      second.tile = tile;

      expect(second.captured, pawn);
      expect(pawn.captured, null);
      expect(second.tile, tile);

    });


  });



  group('position sending and duplicating',(){

    test('duplicating and sending fie fo fum game', (){
        FieFoFumPosition position = FieFoFumPosition();

        position.playerIds = ['a', 'b', 'c', 'd'];
        position.playerQueue = ['a', 'b', 'c', 'd'];
        position.gameId = 'game';

        position.initialise();

        position.playerIds.forEach((p) => position.playerStatus[p] = PlayerStatus.playing);

        expect(position.count, 1);

        FieFoFumPosition duplicate = position.duplicate;
        FieFoFumPosition sent = FieFoFumInjector().getPositionBuilder().build(position.json);

        expect(duplicate.playerIds, position.playerIds);
        expect(duplicate.playerQueue, position.playerQueue);
        expect(duplicate.count, position.count);

        expect(sent.playerIds, position.playerIds);
        expect(sent.playerQueue, position.playerQueue);
        expect(sent.count, position.count);

        position.makeMove(MoveNumber());
        expect(position.count , 2);
        expect(position.playerQueue, ['b', 'c', 'd','a']);

        duplicate = position.duplicate;
        sent = FieFoFumInjector().getPositionBuilder().build(position.json);

        expect(duplicate.playerIds, position.playerIds);
        expect(duplicate.playerQueue, position.playerQueue);
        expect(duplicate.count, position.count);

        expect(sent.playerIds, position.playerIds);
        expect(sent.playerQueue, position.playerQueue);
        expect(sent.count, position.count);
        
    });

  


  });

  group('varous methods', (){
    var ui = LocalInterface(FieFoFumInjector());

    setUp(() async{
      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      ui.newGame.firstPlayer = 'Player 1';
      await ui.startLocalGame();
    });

    test('timer', ()async{

      await Future.delayed(Duration(milliseconds : 1000));

      await ui.game.makeMove(MoveNumber(), ui.game.gameId, ui.position.playerId);
      expect(ui.position.timeLeft['Player 1'], 7);
//      await Future.delayed(Duration(seconds : 8));
//      expect(ui.position.playerStatus['Player 2'], PlayerStatus.out);

    });

    test('color functions',(){

      var color = GameColor(0x12345678);
      expect(color.a, 18);
      expect(color.r, 52);
      expect(color.g, 86);
      expect(color.b, 120);

      expect(color.toInt, 0x12345678);
      expect(color.string, '0x12345678');

      expect(GameColor.fromString('#ffffff').r, 255);
      expect(GameColor.fromString('#ffffff').g, 255);
      expect(GameColor.fromString('#ffffff').b, 255);

      expect(GameColor.fromString('#123456'), GameColor(0xff123456));

    });

    test('setting variables' , (){

      expect( IntSetting(6).value, IntSetting.fromJSON(IntSetting(6).json).value);
      expect( DoubleSetting(6.0).value, DoubleSetting.fromJSON(DoubleSetting(6.0).json).value);
      expect( BoolSetting(true).value, BoolSetting.fromJSON(BoolSetting(true).json).value);
      expect( BoolSetting(false).value, BoolSetting.fromJSON(BoolSetting(false).json).value);
      expect( StringSetting('help').value, StringSetting.fromJSON(StringSetting('help').json).value);
    });

    test('player variable',()async{

      List<String> playerIds = ['a', 'b', 'c', 'd'];

      expect(ui.game.position.playerStatus.string,
          PlayerVariable.playerVariablefromString(ui.game.position.playerStatus.string).string);

      expect(ui.game.position.score.string,
          PlayerVariable.playerVariablefromString(ui.game.position.score.string).string);

      expect(ui.game.position.color.string,
          PlayerVariable.playerVariablefromString(ui.game.position.color.string).string);

      PlayerVariable<bool> bools = PlayerVariable(playerIds, false);

      bools['d'] = true;

      expect(bools['a'], false);
      expect(bools['b'], false);
      expect(bools['c'], false);
      expect(bools['d'], true);

      expect(bools.string, PlayerVariable.playerVariablefromString( bools.string).string);


    });

    test('move tree valuations', (){

      List<String> players = ['a', 'b', 'c', 'd'];

      var testPosition = DummyPosition();
      testPosition.playerIds = players;
      testPosition.values = [2.0,3.0,1.0,4.0];

      expect(testPosition.value('a'), -2);
      expect(testPosition.value('b'), -1);
      expect(testPosition.value('c'), -3);
      expect(testPosition.value('d'), 1);

      MoveTree moveTree = MoveTree(testPosition, 'a');
      expect(moveTree.value, -2);

      var secondMove1 = DummyPosition()
      ..playerIds = players
      ..playerQueue = List()
        ..playerQueue.add('b')
        ..values = [2.0,3.0,1.0,5.0];

      expect(secondMove1.playerId, 'b');

      MoveTree tree1 = MoveTree(secondMove1, 'a');
      expect(tree1.value, -3);

      var secondMove2 = DummyPosition()
        ..playerIds = players
        ..playerQueue = List()
        ..playerQueue.add('b')
        ..values = [2.0,6.0,1.0,5.0];

      expect(secondMove2.playerId, 'b');
      MoveTree tree2 = MoveTree(secondMove2, 'a');
      expect(tree2.value, -4);

      moveTree.branches.add(tree1);
      expect(moveTree.value, -5);

      moveTree.branches.add(tree2);
      expect(moveTree.value, -6);
    });


  });


  group('computer player basics',(){

    test('Basic computer connection', () async{
      var ui = LocalInterface(FieFoFumInjector());
      var computer = ComputerPlayer(FieFoFumInjector());
      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(computer);


      ui.newGame.firstPlayer = "Player 1";
      await ui.startLocalGame();

      computer.send(Echo('hey'));

      Message response = Message.inflate(await next(computer.messagesIn.stream));

      expect(response.runtimeType, EchoResponse);
      expect((response as EchoResponse).text, 'echo hey');

      ui.tryMove(MoveNumber());
      expect((ui.position as FieFoFumPosition).count, 2);
      expect((ui.position.duplicate as FieFoFumPosition).count, 2);

      response = Message.inflate(await next(computer.messagesIn.stream));
      expect(response.runtimeType, ConfirmMove);

      response = Message.inflate(await next(computer.messagesIn.stream));
      expect(response.runtimeType, SuggestMove);

      expect((response as SuggestMove).build(FieFoFumMoveBuilder()).runtimeType, MoveNumber);

      expect((ui.position as FieFoFumPosition).count, 3);
      expect((ui.position as FieFoFumPosition).playerId , 'Player 1');

      ui.tryMove(MoveFie());



      response = Message.inflate(await next(computer.messagesIn.stream));
      expect(response.runtimeType, ConfirmMove);

      response = Message.inflate(await next(computer.messagesIn.stream));
      expect(response.runtimeType, ConfirmMove);

      response = Message.inflate(await next(computer.messagesIn.stream));
      expect((response as SuggestMove).build(FieFoFumMoveBuilder()).runtimeType, MoveNumber);

      expect((ui.position as FieFoFumPosition).playerQueue , ['Player 1', 'Computer 1']);
      expect((ui.position as FieFoFumPosition).playerId , 'Player 1');

      expect((ui.position as FieFoFumPosition).count, 5);
      expect((ui.position as FieFoFumPosition).count, 5);

      ui.tryMove(MoveFo());

//      response = Message.inflate(await next(computer.messagesIn.stream));
//      expect(response.runtimeType, SuggestMove);
//
//      response = Message.inflate(await next(computer.messagesIn.stream));

//      expect((ui.position as FieFoFumPosition).playerQueue , ['Player 1', 'Computer 1']);
//
//      expect((ui.position as FieFoFumPosition).count, 7);
//
//
//      ui.tryMove(MoveFie());
//
//      expect((ui.position as FieFoFumPosition).winner , 'Computer 1');

    },

    );



    tearDown((){

    });

    test('Fie Fo Fum ai flow',() async{
      var ui = LocalInterface(FieFoFumInjector());
      ui.addPlayer(LocalPlayer(ui));
      var computer = ComputerPlayer(FieFoFumInjector());
      ui.newGame.firstPlayer = computer.id;
      ui.addPlayer(computer);
      await ui.startLocalGame();


    });


  });

  group('chess ai',(){

    LocalInterface ui;
    ChessPosition position;
    ComputerPlayer computer;

    String player1 = 'Player 1';
    String gameId = 'local game';


    test('computer testing',() async{

      ui = LocalInterface(ChessInjector());
      ui.addPlayer(LocalPlayer(ui));
      computer = ComputerPlayer(ChessInjector());
      ui.addPlayer(computer);
      ui.newGame.firstPlayer = player1;

      await ui.startLocalGame();
      position = ui.game.position;

      expect(position.runtimeType, ChessPosition);
      expect(position.whitePlayer, player1);
      expect(ui.game.gameId   , gameId);

      expect(ui.position.playerId, player1);

      computer.send(Echo('hey'));

      Message message = Message.inflate(await next(computer.messagesIn.stream));

      expect(message.runtimeType, EchoResponse);

      EchoResponse response = message as EchoResponse;

      expect(response.text, 'echo hey');

      await ui.game.makeMove(ChessMove(
        position.tiles.tile(3, 1),
        position.tiles.tile(3, 3)
      ), gameId, 'Player 1');

      message = Message.inflate(await next(computer.messagesIn.stream));

      expect(message.runtimeType, SuggestMove);

      expect(ChessInjector().getMoveBuilder().build((message as SuggestMove).moveString).runtimeType, ChessMove);

      await ui.game.makeMove(ChessMove(
          position.tiles.tile(4, 1),
          position.tiles.tile(4, 3)
      ), gameId, 'Player 1');

      message = Message.inflate(await next(computer.messagesIn.stream));

      expect(message.runtimeType, SuggestMove);

      expect(ChessInjector().getMoveBuilder().build((message as SuggestMove).moveString).runtimeType, ChessMove);

      expect(ui.position.playerId, player1);

    },



    );

    test('computer testing',()async{
      var position = FieFoFumPosition();

      position.playerIds = ['a','b'];

      position.initialise();

      position.playerStatus['a'] = PlayerStatus.playing;
      position.playerStatus['b'] = PlayerStatus.playing;

      position.lastMove.makeChildren(FieFoFumInjector());

      Computer computer = Computer(FieFoFumInjector());
      computer.position = position;
      computer.playerId = 'a';
      computer.aiDepth = 1;
      computer.thinkingTime = 2;

      MoveQueue moveQueue = MoveQueue(position);
      expect(moveQueue.lines.length, 1);
      moveQueue.lines.forEach((l)=>expect(l.player, 'a'));
      moveQueue.expandAll(5);
//      moveQueue.expandAll(5);
      moveQueue.printQueue();

      moveQueue.lines.forEach((l)=>expect(l.player, 'a'));


      Move move = await computer.findBestMove();
      position.makeMove(move);
      expect(position.playerQueue, ['b','a']);

      move = await computer.findBestMove();
      position.makeMove(move);
      expect(position.playerQueue, ['a','b']);
    });

    test('computer goes first',() async{

      ui = LocalInterface(ChessInjector());
      ui.addPlayer(LocalPlayer(ui));
      computer = ComputerPlayer(ChessInjector());
      ui.addPlayer(computer);
      ui.newGame.firstPlayer = computer.id;

      await ui.startLocalGame();
      position = ui.game.position;

      expect(position.runtimeType, ChessPosition);
      expect(position.whitePlayer, computer.id);
      expect(ui.game.gameId   , gameId);

      expect(ui.position.playerId, computer.id);

      await ui.game.makeMove(ChessMove(
          position.tiles.tile(4, 6),
          position.tiles.tile(4, 4)
      ), gameId, 'Player 1');

      Message message = Message.inflate(await next(computer.messagesIn.stream));

      expect(message.runtimeType, SuggestMove);

      expect(ChessInjector().getMoveBuilder().build((message as SuggestMove).moveString).runtimeType, ChessMove);

    },




    );




  });


  group('Message testing',(){

    var ui = LocalInterface(FieFoFumInjector());

    setUp(() async{
      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      await ui.startLocalGame();
    });


    test('SendPosition',(){
      SendPosition sendPostiion = SendPosition.fromGame(ui.game);

      FieFoFumPosition position = sendPostiion.build(FieFoFumInjector().getPositionBuilder());
      expect(position.count , 1);
      expect(position.playerIds, ['Player 1', 'Player 2', 'Player 3', 'Player 4']);
      expect(position.color['Player 1'], 7);
      expect(position.color['Player 2'], 6);
      expect(position.playerId.substring(0,6)  , 'Player');

      MakeMove makeMove = MakeMove('testGamne', 'player', MoveFie(), ui.position.nextMoveNumber);
      Move move = MakeMove.fromJSON(makeMove.json).getMove(FieFoFumInjector());
      expect(move.runtimeType, MoveFie);

      makeMove = MakeMove('testGamne', 'player', MoveFo(), ui.position.nextMoveNumber);
      move = MakeMove.fromJSON(makeMove.json).getMove(FieFoFumInjector());
      expect(move.runtimeType, MoveFo);

      makeMove = MakeMove('testGamne', 'player', MoveFum(), ui.position.nextMoveNumber);
      move = MakeMove.fromJSON(makeMove.json).getMove(FieFoFumInjector());
      expect(move.runtimeType, MoveFum);

      makeMove = MakeMove('testGamne', 'player', MoveNumber(), ui.position.nextMoveNumber);
      move = MakeMove.fromJSON(makeMove.json).getMove(FieFoFumInjector());
      expect(move.runtimeType, MoveNumber);

    });

    test('game messages', (){

      expect(ChangeScreen('start').screen, GameMessage.inflate(ChangeScreen('start').json).screen);
      expect(RefreshScreen().runtimeType, GameMessage.inflate(RefreshScreen().json).runtimeType);

     expect(ChangeScreen('start').screen, (Message.inflate(ChangeScreen('start').json) as ChangeScreen).screen);


    });

    test('game timer tests',() async{

      LocalInterface ui = LocalInterface(ChessInjector());
      ui.localSettings.randomStart.value = false;
      expect(ui.localSettings.randomStart.value, false);

      ui.resetGame();

      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      ui.newGame.firstPlayer ='Player 1';

      expect(ui.newGame.randomStarter, false);
      expect(ui.newGame.timer, true);

      ui.startLocalGame();

      GameMessage message = await next(ui.events.stream);

      expect(message.runtimeType, GameTimer);

      GameTimer timer = message as GameTimer;

      expect(timer.instruction, 'start');
      expect(timer.playerId, 'Player 1');
      expect(timer.timeLeft, 312.0);

      expect(timer.instruction, GameTimer.fromJSON(timer.json).instruction);
      expect(timer.playerId, GameTimer.fromJSON(timer.json).playerId);
      expect(timer.timeLeft, GameTimer.fromJSON(timer.json).timeLeft);

    });



  });


  group('Fie fo fum basic game ', () {

    var ui = LocalInterface(FieFoFumInjector());

    test('start local fie fo fum game',()async{
      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));

      expect(ui.newGame.players.length, 4);

      await ui.startLocalGame();
      expect(ui.game.position.playerIds, ['Player 1', 'Player 2', 'Player 3', 'Player 4']);

      expect(ui.position.color['Player 1'], Palette.COLOR_WHITE);
      expect(ui.position.color['Player 2'], Palette.COLOR_BLACK);
      expect(ui.position.color['Player 3'], Palette.COLOR_BLUE);
      expect(ui.position.color['Player 4'], Palette.COLOR_RED);

      String winner = ui.position.playerId;

      expect(ui.position.playerQueue.length, 4);
      expect((ui.game.position as FieFoFumPosition).count, 1);
      ui.tryMove(MoveNumber());   // 1 so this is correct 0
      expect(ui.position.playerQueue.length, 4);
      ui.tryMove(MoveFie());   // 2 so this is wrong 1 out
      expect(ui.position.playerQueue.length, 3);
      ui.tryMove(MoveFie());   // 3 so this is good 2
      expect(ui.position.playerQueue.length, 3);
      ui.tryMove(MoveFo());   // 4 so this is wrong 3 out
      expect(ui.position.playerQueue.length, 2);
      ui.tryMove(MoveFo());   // 5 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.tryMove(MoveFie());   // 6 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.tryMove(MoveNumber());   // 7 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.tryMove(MoveNumber());   // 8 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.tryMove(MoveFie());   // 9 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.tryMove(MoveFo());   //10 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.tryMove(MoveNumber());   // 11 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.tryMove(MoveFie());   // 12 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.tryMove(MoveNumber());   // 13 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.tryMove(MoveNumber());   // 14 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.tryMove(MoveFum());   // 15 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.tryMove(MoveFo());   // 16 so this is bad 2
      expect(ui.position.playerQueue.length, 1);
      expect(ui.game.state , GameState.won);
      expect(ui.game.position.winner , winner);
    });




  });

  group('chess basic game',(){

    ChessPosition position;

    setUp((){

      LocalInterface ui = LocalInterface(ChessInjector());

      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      ui.startLocalGame();

      position = ui.game.position;

    });
    

    test('moves for pieces',(){
    
      position.clearPieces();

      Rook rook = Rook(position.tiles)
      ..chessColor = Palette.COLOR_WHITE
      ..tile = position.tiles.tile(4,5);

      List<Tile> legalMoves = rook.legalMoves;

      expect(legalMoves.length, 14);
      expect(legalMoves.contains(position.tiles.tile(3,5)), true);
      expect(legalMoves.contains(position.tiles.tile(2,5)), true);
      expect(legalMoves.contains(position.tiles.tile(1,5)), true);
      expect(legalMoves.contains(position.tiles.tile(0,5)), true);
      expect(legalMoves.contains(position.tiles.tile(5,5)), true);
      expect(legalMoves.contains(position.tiles.tile(6,5)), true);
      expect(legalMoves.contains(position.tiles.tile(7,5)), true);
      expect(legalMoves.contains(position.tiles.tile(4,6)), true);
      expect(legalMoves.contains(position.tiles.tile(4,7)), true);
      expect(legalMoves.contains(position.tiles.tile(4,4)), true);
      expect(legalMoves.contains(position.tiles.tile(4,3)), true);
      expect(legalMoves.contains(position.tiles.tile(4,2)), true);
      expect(legalMoves.contains(position.tiles.tile(4,1)), true);
      expect(legalMoves.contains(position.tiles.tile(4,0)), true);

      position.clearPieces();

      Bishop bishop = Bishop(position.tiles)
        ..chessColor = Palette.COLOR_WHITE
        ..tile = position.tiles.tile(4,5);

      legalMoves.clear();

      legalMoves = bishop.legalMoves;

      expect(legalMoves.length, 11);
      expect(legalMoves.contains(position.tiles.tile(3,4)), true);
      expect(legalMoves.contains(position.tiles.tile(2,3)), true);
      expect(legalMoves.contains(position.tiles.tile(1,2)), true);
      expect(legalMoves.contains(position.tiles.tile(0,1)), true);
      expect(legalMoves.contains(position.tiles.tile(5,4)), true);
      expect(legalMoves.contains(position.tiles.tile(6,3)), true);
      expect(legalMoves.contains(position.tiles.tile(7,2)), true);
      expect(legalMoves.contains(position.tiles.tile(5,6)), true);
      expect(legalMoves.contains(position.tiles.tile(6,7)), true);
      expect(legalMoves.contains(position.tiles.tile(3,6)), true);
      expect(legalMoves.contains(position.tiles.tile(2,7)), true);

      position.clearPieces();

      Queen queen = Queen(position.tiles)
        ..chessColor = Palette.COLOR_WHITE
        ..tile = position.tiles.tile(4,5);

      legalMoves.clear();

      legalMoves = queen.legalMoves;

      expect(legalMoves.length, 25);
      expect(legalMoves.contains(position.tiles.tile(3,4)), true);
      expect(legalMoves.contains(position.tiles.tile(2,3)), true);
      expect(legalMoves.contains(position.tiles.tile(1,2)), true);
      expect(legalMoves.contains(position.tiles.tile(0,1)), true);
      expect(legalMoves.contains(position.tiles.tile(5,4)), true);
      expect(legalMoves.contains(position.tiles.tile(6,3)), true);
      expect(legalMoves.contains(position.tiles.tile(7,2)), true);
      expect(legalMoves.contains(position.tiles.tile(5,6)), true);
      expect(legalMoves.contains(position.tiles.tile(6,7)), true);
      expect(legalMoves.contains(position.tiles.tile(3,6)), true);
      expect(legalMoves.contains(position.tiles.tile(2,7)), true);

      expect(legalMoves.contains(position.tiles.tile(3,4)), true);
      expect(legalMoves.contains(position.tiles.tile(2,3)), true);
      expect(legalMoves.contains(position.tiles.tile(1,2)), true);
      expect(legalMoves.contains(position.tiles.tile(0,1)), true);
      expect(legalMoves.contains(position.tiles.tile(5,4)), true);
      expect(legalMoves.contains(position.tiles.tile(6,3)), true);
      expect(legalMoves.contains(position.tiles.tile(7,2)), true);
      expect(legalMoves.contains(position.tiles.tile(5,6)), true);
      expect(legalMoves.contains(position.tiles.tile(6,7)), true);
      expect(legalMoves.contains(position.tiles.tile(3,6)), true);
      expect(legalMoves.contains(position.tiles.tile(2,7)), true);

      position.clearPieces();

      King king = King(position.tiles)
        ..chessColor = Palette.COLOR_WHITE
        ..tile = position.tiles.tile(4,5);

      legalMoves.clear();

      legalMoves = king.legalMoves;

      expect(legalMoves.length, 8);

      expect(legalMoves.contains(position.tiles.tile(3,5)), true);
      expect(legalMoves.contains(position.tiles.tile(3,6)), true);
      expect(legalMoves.contains(position.tiles.tile(3,4)), true);

      expect(legalMoves.contains(position.tiles.tile(4,4)), true);
      expect(legalMoves.contains(position.tiles.tile(4,6)), true);

      expect(legalMoves.contains(position.tiles.tile(5,4)), true);
      expect(legalMoves.contains(position.tiles.tile(5,6)), true);
      expect(legalMoves.contains(position.tiles.tile(5,5)), true);

      position.clearPieces();

      Pawn pawn = Pawn(position.tiles)
        ..chessColor = Palette.COLOR_WHITE
        ..tile = position.tiles.tile(4,5);

      legalMoves.clear();

      legalMoves = pawn.legalMoves;

      expect(legalMoves.length, 1);
      expect(legalMoves.contains(position.tiles.tile(4,6)), true);

      pawn.tile = position.tiles.tile(4,1);
      legalMoves.clear();
      legalMoves = pawn.legalMoves;
      expect(legalMoves.length, 2);
      expect(legalMoves.contains(position.tiles.tile(4,2)), true);
      expect(legalMoves.contains(position.tiles.tile(4,3)), true);

      position.clearPieces();

      pawn = Pawn(position.tiles)
        ..chessColor = Palette.COLOR_BLACK
        ..tile = position.tiles.tile(4,5);

      legalMoves.clear();

      legalMoves = pawn.legalMoves;

      expect(legalMoves.length, 1);
      expect(legalMoves.contains(position.tiles.tile(4,4)), true);

      position.clearPieces();

      Pawn blackPawn = Pawn(position.tiles)
        ..tile = position.tiles.tile(4, 6)
        ..chessColor = Palette.COLOR_BLACK;

      legalMoves.clear();
      legalMoves = blackPawn.legalMoves;
      expect(legalMoves.length, 2);
      expect(legalMoves.contains(position.tiles.tile(4,5)), true);
      expect(legalMoves.contains(position.tiles.tile(4,4)), true);

      position.clearPieces();

      Knight knight = Knight(position.tiles)
        ..chessColor = Palette.COLOR_WHITE
        ..tile = position.tiles.tile(4,5);

      legalMoves.clear();

      legalMoves = knight.legalMoves;

      expect(legalMoves.length, 8);

      expect(legalMoves.contains(position.tiles.tile(3,7)), true);
      expect(legalMoves.contains(position.tiles.tile(5,7)), true);

      expect(legalMoves.contains(position.tiles.tile(2,4)), true);
      expect(legalMoves.contains(position.tiles.tile(2,6)), true);

      expect(legalMoves.contains(position.tiles.tile(5,3)), true);
      expect(legalMoves.contains(position.tiles.tile(3,3)), true);

      expect(legalMoves.contains(position.tiles.tile(6,6)), true);
      expect(legalMoves.contains(position.tiles.tile(6,4)), true);

    });

    test('pieces interacting',(){

      position.clearPieces();

      Rook whiteRook = Rook(position.tiles)
        ..chessColor = Palette.COLOR_WHITE
        ..tile = position.tiles.tile(4,5);

      Pawn whitePawn = Pawn(position.tiles)
        ..chessColor = Palette.COLOR_WHITE
        ..tile = position.tiles.tile(3,5);

      Pawn blackPawn = Pawn(position.tiles)
        ..chessColor = Palette.COLOR_BLACK
        ..tile = position.tiles.tile(1,6);

      expect(whiteRook.isFriendly(whitePawn), true);
      expect(position.tiles.tile(2,5).tileOccupation(whiteRook ), OccupationStatus.neutral);
      expect(position.tiles.tile(4,5).tileOccupation(whitePawn ), OccupationStatus.friendly);
      expect(position.tiles.tile(3,5).tileOccupation(whiteRook ), OccupationStatus.friendly);

      expect(whiteRook.isFriendly(blackPawn), false);
      expect(position.tiles.tile(2,5).tileOccupation(blackPawn ), OccupationStatus.neutral);
      expect(position.tiles.tile(4,5).tileOccupation(blackPawn ), OccupationStatus.enemy);
      expect(position.tiles.tile(3,5).tileOccupation(blackPawn ), OccupationStatus.enemy);
    });


    test('game setup',() async{

      LocalInterface ui = LocalInterface(ChessInjector());

      NewGame advert = NewGame(ChessSettings());
      Player white = LocalPlayer(ui)
        ..id = 'white player';
      Player black = LocalPlayer(ui)
        .. id = 'black player';

      advert.players.add(white);
      advert.players.add(black);
      advert.firstPlayer = white.id;

      var chessGame = Game.fromNewGame(ChessInjector(), advert);

      chessGame.initialise();

      expect(chessGame.position.playerId, white.id);
      expect(chessGame.position.playerQueue[0], white.id);
      expect(chessGame.position.playerQueue[1], black.id);

      ChessPosition chessPosition = chessGame.position;

      expect(chessPosition.whiteArmy.length, 16);
      expect(chessPosition.blackArmy.length, 16);

      

    });

    test('game duplication',(){




    });





    test('game setup random first player',() async{

      LocalInterface ui = LocalInterface(ChessInjector());

      NewGame advert = NewGame(ChessSettings());
      Player white = LocalPlayer(ui)
        ..id = 'white player';
      Player black = LocalPlayer(ui)
        .. id = 'black player';

      advert.players.add(white);
      advert.players.add(black);

      var chessGame = Game.fromNewGame(ChessInjector(), advert);

      chessGame.initialise();

      expect(chessGame.position.playerId, (chessGame.position as ChessPosition).whitePlayer);
      expect(chessGame.position.playerQueue[0], (chessGame.position as ChessPosition).whitePlayer);
      expect(chessGame.position.playerQueue[1], (chessGame.position as ChessPosition).blackPlayer);
      expect(((chessGame.position as ChessPosition).whitePlayer
          == (chessGame.position as ChessPosition).blackPlayer), false);

    });

    test('local interface chess game',(){

      LocalInterface ui = LocalInterface(ChessInjector());
      ui.addPlayer(LocalPlayer(ui));
      ui.addPlayer(LocalPlayer(ui));
      ui.startLocalGame();

      (ui.input as ChessInput).tapTile((ui.position as ChessPosition).tiles.tile(0,1));

      (ui.input as ChessInput).tapTile((ui.position as ChessPosition).tiles.tile(0,2));



    });

    test('basic ai functions',() async{
      LocalInterface ui = LocalInterface(ChessInjector());
      ui.addPlayer(LocalPlayer(ui));

      ComputerPlayer computerPlayer = ComputerPlayer(ChessInjector());

      ui.addPlayer(computerPlayer);
      ui.newGame.firstPlayer = ('Player 1');
      await ui.startLocalGame();

      ChessMove move = ChessMove((ui.position as ChessPosition).tiles.tile(1, 1),
      (ui.position as ChessPosition).tiles.tile(1, 3));

      ui.tryMove(move);

      await Future.delayed(Duration(milliseconds : 100));

//      (ui.position as ChessPosition).printBoard();


    });

  });


  group ('basic stream server',(){

    GameServer server = GameServer(FieFoFumInjector());
    StreamHttpInterface ui = StreamHttpInterface(FieFoFumInjector(), server);

    setUp(() async {
      await server.db.testData();
      await ui.login('emma', 'e1234');

    });

    test('communication basics',() async{

//      ui.connection.send(RequestPlayerList.code);
//
//      expect((await nextMessage(ui.connection.messagesIn.stream)), RequestPlayerList.code + 'Emma');
//
//      expect(ui.connection.clients.length, 1);
//      expect(server.numberOfClients, 1);
//
//      await ui.connection.login('henry', 'h1235');
//      expect(server.numberOfClients, 1);
//
//      await ui.connection.login('henry', 'h1234');
//      expect(server.numberOfClients, 2);

    });


  tearDown(() async {
      await ui.logout();
    });


  },
  );

  group('Game test',() {
    GameServer server = GameServer(FieFoFumInjector());
    StreamHttpInterface henry = StreamHttpInterface(FieFoFumInjector(), server);
    StreamHttpInterface james = StreamHttpInterface(FieFoFumInjector(), server);
    StreamHttpInterface sarah = StreamHttpInterface(FieFoFumInjector(), server);
    StreamHttpInterface trace = StreamHttpInterface(FieFoFumInjector(), server);

    setUp(() async {
      await server.db.testData();

      await henry.login('henry', 'h1234');
      await james.login('james', 'j1234');
      await sarah.login('sarah', 's1234');
      await trace.login('trace', 't1234');

    });

    test('Logins and chat',() async{

      expect(server.numberOfClients, 4);
      henry.connection.send(RequestPlayerList());

      var message = Message.inflate(await next(henry.connection.messagesIn.stream));

      expect(message.runtimeType, PlayerList);
      var playerList = message as PlayerList;
      expect(playerList.players.length, 4);

      expect(playerList.players, ['Henry', 'Jim', 'Sarah', 'Tracy']);

      henry.sendChat('hi');
      expect((Message.inflate(await next(james.connection.messagesIn.stream))).runtimeType, ChatMessage);
      expect(james.chatMessages.length,1);
      expect(james.chatMessages[0].from,'henry');
      expect(james.chatMessages[0].text,'hi');

      james.sendChat('Hows it going');
      expect((Message.inflate(await next(henry.connection.messagesIn.stream))).runtimeType, ChatMessage);
      expect(henry.chatMessages.length,2);
      expect(henry.chatMessages[0].from,'henry');
      expect(henry.chatMessages[0].text,'hi');
      expect(henry.chatMessages[1].from,'james');
      expect(henry.chatMessages[1].text,'Hows it going');

      sarah.sendMessage('james', 'hello james');
      expect((Message.inflate(await next(james.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(james.privateMessages.length, 1);
      expect(james.privateMessages[0].from, 'sarah');
      expect(james.privateMessages[0].text, 'hello james');

      expect(sarah.privateMessages.length, 1);
      expect(sarah.privateMessages[0].from, 'sarah');
      expect(sarah.privateMessages[0].text, 'hello james');

      james.sendMessage('sarah', 'yo');
      expect((Message.inflate(await next(sarah.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(sarah.privateMessages.length, 2);
      expect(sarah.privateMessages[1].from, 'james');
      expect(sarah.privateMessages[1].text, 'yo');

      henry.sendMessage('emma', 'hey Emma');
      expect((Message.inflate(await next(henry.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(henry.privateMessages.length, 1);
      expect(henry.privateMessages[0].from, 'server');
      expect(henry.privateMessages[0].text, 'emma is not online');

    });

    test('advertise and start fie fo fum game',() async{

      expect(server.numberOfClients, 4);
      expect(james.adverts.length, 0);
      henry.advertiseGame();
      expect((Message.inflate(await next(james.connection.messagesIn.stream))).runtimeType, NewGame);
      expect(james.adverts.length, 1);
      james.joinGame(james.adverts[0]);
       expect((Message.inflate(await next(james.connection.messagesIn.stream))).runtimeType, Success);

      henry.joinGame(henry.adverts[0]);
      expect((Message.inflate(await next(henry.connection.messagesIn.stream))).runtimeType, Success);
      sarah.joinGame(sarah.adverts[0]);
     expect((Message.inflate(await next(sarah.connection.messagesIn.stream))).runtimeType, Success);
      trace.joinGame(trace.adverts[0]);
      expect((Message.inflate(await next(trace.connection.messagesIn.stream))).runtimeType, Success);

      henry.startGame(henry.adverts[0]);
      expect((Message.inflate(await next(henry.connection.messagesIn.stream))).runtimeType, Success);

      henry.status = PlayerStatus.ready;
      james.status = PlayerStatus.ready;
      sarah.status = PlayerStatus.ready;
      trace.status = PlayerStatus.ready;

      var message = Message.inflate(await next(henry.connection.messagesIn.stream));

      expect(message.runtimeType, SetStatus);
      var setStatus = message as SetStatus;
      expect(setStatus.status, PlayerStatus.ready);

      //TODO make two or three moves

    });


    tearDown(() async {
      await henry.logout();
      await james.logout();
      await sarah.logout();
      await trace.logout();
    });



  });


  group('web socket connection',() {
    LocalHostHttpInterface emma = LocalHostHttpInterface(FieFoFumInjector());
    LocalHostHttpInterface henry = LocalHostHttpInterface(FieFoFumInjector());

    setUp(() async {

      // dart /Users/stephenpoole/WebstormProjects/game_server/bin/resource_server.dart

      await emma.login('emma', 'e1234');
    });

    test('communication basics',() async{

//      emma.connection.send(RequestPlayerList.code);
//
//      expect((await nextMessage(emma.connection.messagesIn.stream)), RequestPlayerList.code + 'Emma');
//
//      expect(emma.connection.clients.length, 1);
//
//      await henry.login('henry', 'h1235');
//
//      emma.connection.send(RequestPlayerList.code);
//      expect((await nextMessage(emma.connection.messagesIn.stream)), RequestPlayerList.code + 'Emma');
//
//      await henry.login('henry', 'h1234');
//      expect((await nextMessage(emma.connection.messagesIn.stream)), RequestPlayerList.code + 'Emma' + Command.delimiter + 'Henry');


    });

    tearDown(() async {
      await emma.logout();
      await henry.logout();
    });


  }, skip: 'server test'
  );

  group('Websocket Game test',() {

    LocalHostHttpInterface henry = LocalHostHttpInterface(FieFoFumInjector());
    LocalHostHttpInterface james = LocalHostHttpInterface(FieFoFumInjector());
    LocalHostHttpInterface sarah = LocalHostHttpInterface(FieFoFumInjector());
    LocalHostHttpInterface trace = LocalHostHttpInterface(FieFoFumInjector());

    setUp(() async {

      // dart C:\Users\Stephen\growing_games\game_server\bin\resource_server.dart


      await henry.login('henry', 'h1234');
      await james.login('james', 'j1234');
      await sarah.login('sarah', 's1234');
      await trace.login('trace', 't1234');
    });

    test('Logins and chat',() async{

       henry.connection.send(RequestPlayerList());

      var message = Message.inflate(await next(henry.connection.messagesIn.stream));

      expect(message.runtimeType, PlayerList);
      var playerList = message as PlayerList;
      expect(playerList.players.length, 4);

      expect(playerList.players, ['Henry', 'Jim', 'Sarah', 'Tracy']);

      henry.sendChat('hi');
      expect((Message.inflate(await next(james.connection.messagesIn.stream))).runtimeType, ChatMessage);
      expect(james.chatMessages.length,1);
      expect(james.chatMessages[0].from,'henry');
      expect(james.chatMessages[0].text,'hi');

      james.sendChat('Hows it going');
      expect((Message.inflate(await next(henry.connection.messagesIn.stream))).runtimeType, ChatMessage);
      expect(henry.chatMessages.length,2);
      expect(henry.chatMessages[0].from,'henry');
      expect(henry.chatMessages[0].text,'hi');
      expect(henry.chatMessages[1].from,'james');
      expect(henry.chatMessages[1].text,'Hows it going');

      sarah.sendMessage('james', 'hello james');
      expect((Message.inflate(await next(james.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(james.privateMessages.length, 1);
      expect(james.privateMessages[0].from, 'sarah');
      expect(james.privateMessages[0].text, 'hello james');

      expect(sarah.privateMessages.length, 1);
      expect(sarah.privateMessages[0].from, 'sarah');
      expect(sarah.privateMessages[0].text, 'hello james');

      james.sendMessage('sarah', 'yo');
      expect((Message.inflate(await next(sarah.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(sarah.privateMessages.length, 2);
      expect(sarah.privateMessages[1].from, 'james');
      expect(sarah.privateMessages[1].text, 'yo');

      henry.sendMessage('emma', 'hey Emma');
      expect((Message.inflate(await next(henry.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(henry.privateMessages.length, 1);
      expect(henry.privateMessages[0].from, 'server');
      expect(henry.privateMessages[0].text, 'emma is not online');

    });

    test('Logins and advertise game',() async{





    });


    tearDown(() async {
      await henry.logout();
      await james.logout();
      await sarah.logout();
      await trace.logout();
    });





  }, skip: 'server test'
  );



}