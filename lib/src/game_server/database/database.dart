


import 'package:game_server/src/messages/message.dart';

import 'record.dart';

class Database{

  List<Record> _records = new List();

  Future<Message> addRecord(Record record) async{

    _records.add(record);

    return Success();
  }

  Future<Record> getRecordWithId(String string) async{

    Record record;

    _records.forEach((r) {
      if(r.id == string) record = r;
    });

    return record;
  }

  Future<Record> getRecordWithDisplayName(String string)async{
    Record record;

    _records.forEach((r) {
      if(r.displayName == string) record = r;
    });

    return record;

  }

  Future<Record> getRecordWithEmail(String string)async{
    Record record;

    _records.forEach((r) {
      if(r.email == string) record = r;
    });

    return record;

  }



  testData() async{

    _records.clear();

    await addRecord(new Record()
      ..id = 'henry'
      ..displayName = 'Henry'
      .. password ='h1234'
      ..email = 'henry@email.com');

    await addRecord(new Record()
      ..id = 'james'
      ..displayName = 'Jim'
      .. password ='j1234'
      ..email = 'jim@email.com');

    await addRecord(new Record()
      ..id = 'sarah'
      ..displayName = 'Sarah'
      .. password ='s1234'
      ..email = 'sarah@email.com');

    await addRecord(new Record()
      ..id = 'emma'
      ..displayName = 'Emma'
      .. password ='e1234'
      ..email = 'emma@email.com');

    await addRecord(new Record()
      ..id = 'trace'
      ..displayName = 'Tracy'
      .. password ='t1234'
      ..email = 'tracy@email.com');

  }


}
