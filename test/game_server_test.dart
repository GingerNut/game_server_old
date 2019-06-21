
import 'dart:async';
import 'dart:math';

import 'package:game_server/examples/chess/lib/chess_injector.dart';
import 'package:game_server/examples/chess/lib/chess_notation.dart';
import 'package:game_server/examples/chess/lib/chess_position.dart';
import 'package:game_server/examples/chess/lib/chess_settings.dart';
import 'package:game_server/examples/chess/lib/chess_board.dart';
import 'package:game_server/examples/chess/lib/pieces/bishop.dart';
import 'package:game_server/examples/chess/lib/pieces/chess_piece.dart';
import 'package:game_server/examples/chess/lib/pieces/pawn.dart';
import 'package:game_server/examples/chess/lib/pieces/rook.dart';
import 'package:game_server/examples/fie_fo_fum/lib/fie_fo_fum_injector.dart';
import 'package:game_server/examples/fie_fo_fum/lib/fie_fo_fum_move_builder.dart';
import 'package:game_server/examples/fie_fo_fum/lib/fie_fo_fum_position.dart';
import 'package:game_server/examples/fie_fo_fum/lib/move_fie.dart';
import 'package:game_server/examples/fie_fo_fum/lib/move_fo.dart';
import 'package:game_server/examples/fie_fo_fum/lib/move_fum.dart';
import 'package:game_server/examples/fie_fo_fum/lib/move_number.dart';
import 'package:game_server/game_server.dart';
import 'package:game_server/src/design/palette.dart';
import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/game/player/player_variable.dart';
import 'package:game_server/src/interface/local_interface.dart';
import 'package:game_server/src/messages/chat/chat_message.dart';
import 'package:game_server/src/messages/chat/private_message.dart';
import 'package:game_server/src/messages/command/echo.dart';
import 'package:game_server/src/messages/command/make_move.dart';
import 'package:game_server/src/messages/command/new_game.dart';
import 'package:game_server/src/messages/command/request_player_list.dart';
import 'package:game_server/src/messages/command/send_position.dart';
import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/confirm_move.dart';
import 'package:game_server/src/messages/response/echo_response.dart';
import 'package:game_server/src/messages/response/player_list.dart';
import 'package:game_server/src/messages/response/success.dart';

import 'package:test/test.dart';


import 'package:game_server/src/interface/local_http_interface.dart';
import 'package:game_server/src/interface/stream_http_interface.dart';


void main()async{

  Future <String> nextMessage(Stream<String> stream )async{

    await for(String string in stream){
      return string;
    }
  }

  Future waitForAllConfirmed(Game game) async{

    while(game.unconfirmed.isNotEmpty){
      await Future.delayed(Duration(milliseconds : 10));
    }
    return;
  }

  group('notation', (){

    test('chess notation', (){

      expect(ChessNotation().labelTile(0,0), 'a1');
      expect(ChessNotation().labelTile(3,1), 'b4');
      expect(ChessNotation().labelTile(5,3), 'd6');
      expect(ChessNotation().labelTile(7,7), 'h8');
    });


  });

  group('board functions',(){

    test('all directions square',(){

      var board = Board.squareTiles(8, ConnectionScheme.allDirections);

      expect(board.tiles.length, 64);


    });

    test('pieces getting teken',(){

      ChessBoard board = ChessBoard.empty();

      expect(board.tiles.length, 64);

      Pawn pawn = Pawn(board);

      Tile tile = board.tile(0, 0);
      pawn.startingPosition = tile;
      pawn.setup();

      expect(pawn.tile, board.tile(0,0));
      Pawn second = Pawn(board);
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
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      await ui.startGame(ui.newGame ..firstPlayer ='Player 1');
    });

    test('timer', ()async{

      await Future.delayed(Duration(milliseconds : 1000));

      await ui.game.makeMove(MoveNumber(), ui.game.gameId, ui.position.playerId);
      expect(ui.position.timeLeft['Player 1'], 7);
//      await Future.delayed(Duration(seconds : 8));
//      expect(ui.position.playerStatus['Player 2'], PlayerStatus.out);

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

  });


  group('computer player basics',(){

    var ui = LocalInterface(FieFoFumInjector());
    var computer = ComputerPlayer(FieFoFumInjector());
    ui.addPlayer(Player());
    ui.addPlayer(computer);

    setUp(()async{
      await ui.startGame(ui.newGame .. firstPlayer = 'Player 1');
    });


    test('Basic computer connection', () async{
      computer.send(Echo('hey'));

      Message response = Message.inflate(await nextMessage(computer.messagesIn.stream));

      expect(response.runtimeType, EchoResponse);
      expect((response as EchoResponse).text, 'echo hey');

      ui.makeMove(MoveNumber());
      expect((ui.position as FieFoFumPosition).count, 2);
      expect((ui.position.duplicate as FieFoFumPosition).count, 2);

      response = Message.inflate(await nextMessage(computer.messagesIn.stream));
      expect(response.runtimeType, ConfirmMove);

      response = Message.inflate(await nextMessage(computer.messagesIn.stream));
      expect(response.runtimeType, MakeMove);

      expect((response as MakeMove).build(FieFoFumMoveBuilder()).runtimeType, MoveNumber);

      expect((ui.position as FieFoFumPosition).count, 3);
      expect((ui.position as FieFoFumPosition).playerId , 'Player 1');

      ui.makeMove(MoveFie());



      response = Message.inflate(await nextMessage(computer.messagesIn.stream));
      expect(response.runtimeType, ConfirmMove);

      response = Message.inflate(await nextMessage(computer.messagesIn.stream));
      expect(response.runtimeType, ConfirmMove);

      response = Message.inflate(await nextMessage(computer.messagesIn.stream));
      expect((response as MakeMove).build(FieFoFumMoveBuilder()).runtimeType, MoveNumber);

      expect((ui.position as FieFoFumPosition).playerQueue , ['Player 1', 'Computer 1']);
      expect((ui.position as FieFoFumPosition).playerId , 'Player 1');

      expect((ui.position as FieFoFumPosition).count, 5);
      expect((ui.position as FieFoFumPosition).count, 5);

      ui.makeMove(MoveFo());

      response = Message.inflate(await nextMessage(computer.messagesIn.stream));
//      expect(response.runtimeType, ConfirmMove);

      response = Message.inflate(await nextMessage(computer.messagesIn.stream));

//      expect((ui.position as FieFoFumPosition).playerQueue , ['Computer 1', 'Player 1']);
//
//      expect((ui.position as FieFoFumPosition).count, 7);
//
//      await waitForAllConfirmed(ui.game);
//      ui.makeMove(MoveFie());
//
//      expect((ui.position as FieFoFumPosition).winner , 'Computer 1');

    },
    );



    tearDown((){

      ui.game.tidyUp();

    });

  });

  group('Message testing',(){

    var ui = LocalInterface(FieFoFumInjector());

    setUp(() async{
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      await ui.startGame(ui.newGame);
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
      Move move = MakeMove.fromJSON(makeMove.json).build(FieFoFumMoveBuilder());
      expect(move.runtimeType, MoveFie);

      makeMove = MakeMove('testGamne', 'player', MoveFo(), ui.position.nextMoveNumber);
      move = MakeMove.fromJSON(makeMove.json).build(FieFoFumMoveBuilder());
      expect(move.runtimeType, MoveFo);

      makeMove = MakeMove('testGamne', 'player', MoveFum(), ui.position.nextMoveNumber);
      move = MakeMove.fromJSON(makeMove.json).build(FieFoFumMoveBuilder());
      expect(move.runtimeType, MoveFum);

      makeMove = MakeMove('testGamne', 'player', MoveNumber(), ui.position.nextMoveNumber);
      move = MakeMove.fromJSON(makeMove.json).build(FieFoFumMoveBuilder());
      expect(move.runtimeType, MoveNumber);



    });



  });


  group('Fie fo fum basic game ', () {

    var ui = LocalInterface(FieFoFumInjector());

    test('start local fie fo fum game',()async{
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      ui.addPlayer(Player());


      expect(ui.newGame.players.length, 4);

      await ui.startGame(ui.newGame);
      expect(ui.game.position.playerIds, ['Player 1', 'Player 2', 'Player 3', 'Player 4']);

      expect(ui.position.color['Player 1'], Palette.COLOR_WHITE);
      expect(ui.position.color['Player 2'], Palette.COLOR_BLACK);
      expect(ui.position.color['Player 3'], Palette.COLOR_BLUE);
      expect(ui.position.color['Player 4'], Palette.COLOR_RED);

      String winner = ui.position.playerId;

      expect(ui.position.playerQueue.length, 4);
      expect((ui.game.position as FieFoFumPosition).count, 1);
      ui.makeMove(MoveNumber());   // 1 so this is correct 0
      expect(ui.position.playerQueue.length, 4);
      ui.makeMove(MoveFie());   // 2 so this is wrong 1 out
      expect(ui.position.playerQueue.length, 3);
      ui.makeMove(MoveFie());   // 3 so this is good 2
      expect(ui.position.playerQueue.length, 3);
      ui.makeMove(MoveFo());   // 4 so this is wrong 3 out
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFo());   // 5 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFie());   // 6 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveNumber());   // 7 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveNumber());   // 8 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFie());   // 9 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFo());   //10 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveNumber());   // 11 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFie());   // 12 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveNumber());   // 13 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveNumber());   // 14 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFum());   // 15 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFo());   // 16 so this is bad 2
      expect(ui.position.playerQueue.length, 1);
      expect(ui.game.state , GameState.won);
      expect(ui.game.position.winner , winner);
    });




  });

  group('chess basic game',(){

    test('moves for pieces',(){
      ChessBoard board = ChessBoard.empty();

      Rook rook = Rook(board)
      ..startingPosition = board.tile(0, 0)
      ..chessColor = ChessColor.white
      ..tile = board.tile(4,5);

      List<Tile> legalMoves = rook.legalMoves;

      expect(legalMoves.length, 14);
      expect(legalMoves.contains(board.tile(3,5)), true);
      expect(legalMoves.contains(board.tile(2,5)), true);
      expect(legalMoves.contains(board.tile(1,5)), true);
      expect(legalMoves.contains(board.tile(0,5)), true);
      expect(legalMoves.contains(board.tile(5,5)), true);
      expect(legalMoves.contains(board.tile(6,5)), true);
      expect(legalMoves.contains(board.tile(7,5)), true);
      expect(legalMoves.contains(board.tile(4,6)), true);
      expect(legalMoves.contains(board.tile(4,7)), true);
      expect(legalMoves.contains(board.tile(4,4)), true);
      expect(legalMoves.contains(board.tile(4,3)), true);
      expect(legalMoves.contains(board.tile(4,2)), true);
      expect(legalMoves.contains(board.tile(4,1)), true);
      expect(legalMoves.contains(board.tile(4,0)), true);

      board = ChessBoard.empty();

      Bishop bishop = Bishop(board)
        ..startingPosition = board.tile(0, 0)
        ..chessColor = ChessColor.white
        ..tile = board.tile(4,5);

      legalMoves.clear();

      legalMoves = bishop.legalMoves;

      expect(legalMoves.length, 11);
      expect(legalMoves.contains(board.tile(3,4)), true);
      expect(legalMoves.contains(board.tile(2,3)), true);
      expect(legalMoves.contains(board.tile(1,2)), true);
      expect(legalMoves.contains(board.tile(0,1)), true);
      expect(legalMoves.contains(board.tile(5,4)), true);
      expect(legalMoves.contains(board.tile(6,3)), true);
      expect(legalMoves.contains(board.tile(7,2)), true);
      expect(legalMoves.contains(board.tile(5,6)), true);
      expect(legalMoves.contains(board.tile(6,7)), true);
      expect(legalMoves.contains(board.tile(3,6)), true);
      expect(legalMoves.contains(board.tile(2,7)), true);







    });




    test('game setup',() async{

      NewGame advert = NewGame(ChessSettings());
      Player white = Player()
        ..id = 'white player';
      Player black = Player()
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

      expect(chessPosition.board.whiteArmy.length, 16);
      expect(chessPosition.board.blackArmy.length, 16);

    });

    test('game setup random first player',() async{

      NewGame advert = NewGame(ChessSettings());
      Player white = Player()
        ..id = 'white player';
      Player black = Player()
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

      var message = Message.inflate(await nextMessage(henry.connection.messagesIn.stream));

      expect(message.runtimeType, PlayerList);
      var playerList = message as PlayerList;
      expect(playerList.players.length, 4);

      expect(playerList.players, ['Henry', 'Jim', 'Sarah', 'Tracy']);

      henry.sendChat('hi');
      expect((Message.inflate(await nextMessage(james.connection.messagesIn.stream))).runtimeType, ChatMessage);
      expect(james.chatMessages.length,1);
      expect(james.chatMessages[0].from,'henry');
      expect(james.chatMessages[0].text,'hi');

      james.sendChat('Hows it going');
      expect((Message.inflate(await nextMessage(henry.connection.messagesIn.stream))).runtimeType, ChatMessage);
      expect(henry.chatMessages.length,2);
      expect(henry.chatMessages[0].from,'henry');
      expect(henry.chatMessages[0].text,'hi');
      expect(henry.chatMessages[1].from,'james');
      expect(henry.chatMessages[1].text,'Hows it going');

      sarah.sendMessage('james', 'hello james');
      expect((Message.inflate(await nextMessage(james.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(james.privateMessages.length, 1);
      expect(james.privateMessages[0].from, 'sarah');
      expect(james.privateMessages[0].text, 'hello james');

      expect(sarah.privateMessages.length, 1);
      expect(sarah.privateMessages[0].from, 'sarah');
      expect(sarah.privateMessages[0].text, 'hello james');

      james.sendMessage('sarah', 'yo');
      expect((Message.inflate(await nextMessage(sarah.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(sarah.privateMessages.length, 2);
      expect(sarah.privateMessages[1].from, 'james');
      expect(sarah.privateMessages[1].text, 'yo');

      henry.sendMessage('emma', 'hey Emma');
      expect((Message.inflate(await nextMessage(henry.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(henry.privateMessages.length, 1);
      expect(henry.privateMessages[0].from, 'server');
      expect(henry.privateMessages[0].text, 'emma is not online');

    });

    test('advertise and start fie fo fum game',() async{

      expect(server.numberOfClients, 4);
      expect(james.adverts.length, 0);
      henry.advertiseGame();
      expect((Message.inflate(await nextMessage(james.connection.messagesIn.stream))).runtimeType, NewGame);
      expect(james.adverts.length, 1);
      james.joinGame(james.adverts[0]);
       expect((Message.inflate(await nextMessage(james.connection.messagesIn.stream))).runtimeType, Success);

      henry.joinGame(henry.adverts[0]);
      expect((Message.inflate(await nextMessage(henry.connection.messagesIn.stream))).runtimeType, Success);
      sarah.joinGame(sarah.adverts[0]);
     expect((Message.inflate(await nextMessage(sarah.connection.messagesIn.stream))).runtimeType, Success);
      trace.joinGame(trace.adverts[0]);
      expect((Message.inflate(await nextMessage(trace.connection.messagesIn.stream))).runtimeType, Success);

      henry.startGame(henry.adverts[0]);
      expect((Message.inflate(await nextMessage(henry.connection.messagesIn.stream))).runtimeType, Success);

      henry.status = PlayerStatus.ready;
      james.status = PlayerStatus.ready;
      sarah.status = PlayerStatus.ready;
      trace.status = PlayerStatus.ready;

      var message = Message.inflate(await nextMessage(henry.connection.messagesIn.stream));

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

      var message = Message.inflate(await nextMessage(henry.connection.messagesIn.stream));

      expect(message.runtimeType, PlayerList);
      var playerList = message as PlayerList;
      expect(playerList.players.length, 4);

      expect(playerList.players, ['Henry', 'Jim', 'Sarah', 'Tracy']);

      henry.sendChat('hi');
      expect((Message.inflate(await nextMessage(james.connection.messagesIn.stream))).runtimeType, ChatMessage);
      expect(james.chatMessages.length,1);
      expect(james.chatMessages[0].from,'henry');
      expect(james.chatMessages[0].text,'hi');

      james.sendChat('Hows it going');
      expect((Message.inflate(await nextMessage(henry.connection.messagesIn.stream))).runtimeType, ChatMessage);
      expect(henry.chatMessages.length,2);
      expect(henry.chatMessages[0].from,'henry');
      expect(henry.chatMessages[0].text,'hi');
      expect(henry.chatMessages[1].from,'james');
      expect(henry.chatMessages[1].text,'Hows it going');

      sarah.sendMessage('james', 'hello james');
      expect((Message.inflate(await nextMessage(james.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(james.privateMessages.length, 1);
      expect(james.privateMessages[0].from, 'sarah');
      expect(james.privateMessages[0].text, 'hello james');

      expect(sarah.privateMessages.length, 1);
      expect(sarah.privateMessages[0].from, 'sarah');
      expect(sarah.privateMessages[0].text, 'hello james');

      james.sendMessage('sarah', 'yo');
      expect((Message.inflate(await nextMessage(sarah.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(sarah.privateMessages.length, 2);
      expect(sarah.privateMessages[1].from, 'james');
      expect(sarah.privateMessages[1].text, 'yo');

      henry.sendMessage('emma', 'hey Emma');
      expect((Message.inflate(await nextMessage(henry.connection.messagesIn.stream))).runtimeType, PrivateMessage);
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