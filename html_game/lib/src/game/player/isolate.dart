part of game;


main(List<String> args, SendPort sendPort) {

  ReceivePort receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);

  //Computer computer = Computer(SomeInjector(), receivePort, sendPort);

//  computer.initialise();

}