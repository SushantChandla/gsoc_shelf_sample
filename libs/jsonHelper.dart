import 'package:shelf/shelf.dart' as shelf;
import 'dart:convert';
import 'dart:io';

Future<shelf.Response> jsonGetHandler(shelf.Request request) async {
  return shelf.Response.ok(
    await File('data.json').readAsString(),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
}

Future<shelf.Response> jsonPostHandler(shelf.Request request) async {
  var data = await request.readAsString();
  var jsonData = jsonEncode(data);
  var jsonFile = jsonDecode(await File('data.json').readAsString()) as List;

  var dataList = [jsonData];
  for (var i in jsonFile) {
    dataList.add(jsonEncode(i));
  }

  File('data.json').openWrite().write(dataList);

  return shelf.Response.ok('DATA ADDED');
}
