import 'dart:convert';
import 'dart:io';
import 'dart:async' show runZoned;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

var basePath = 'build/';
Future<void> main() async {
  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(_handleRequest);
  // var server = await io.serve(handler, 'localhost', 8080);
  // print('Serving at http://${server.address.host}:${server.port}');

  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9999 : int.parse(portEnv);

  runZoned(() {
    io.serve(handler, '0.0.0.0', port);
    print("Serving  on port $port");
  }, onError: (e, stackTrace) => print('Oh noes! $e $stackTrace'));
}

Future<shelf.Response> _handleRequest(shelf.Request request) async {
  if (request.url.path.isEmpty) return shelf.Response.found('/index.html');

  if (request.url.path == 'json/') {
    return _jsonRequests(request);
  }

  var contentType = 'text/html';
  if (request.url.path.contains('.')) {
    var t = request.url.path.split('.').last;
    switch (t.toLowerCase()) {
      case 'css':
        contentType = 'text/css';
        break;
      case 'js':
        contentType = 'text/javascript';
        break;
      case 'pdf':
        contentType = 'application/pdf';
        break;
      case 'png':
        contentType='image/png';
        break;
    }
  }

  var out = await getFile(request.url.toFilePath());
  return shelf.Response.ok(
    await out.readAsBytes(),
    headers: {HttpHeaders.contentTypeHeader: contentType},
  );
}

Future<shelf.Response> _jsonRequests(shelf.Request request) async {
  if (request.url.path == 'json/') {
    if (request.method == 'POST') {
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
    if (request.method == 'GET') {
      return shelf.Response.ok(
        await File('data.json').readAsString(),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
    }
    return shelf.Response.notFound(
        await File(basePath + '404.html').readAsString());
  }
}

Future<File> getFile(String urlPath) async {
  var file = File(basePath + urlPath);
  if (await file.exists()) {
    return file;
  }
  if (!urlPath.contains('.')) {
    file = File(basePath + urlPath + '.html');
    if (await file.exists()) {
      return file;
    }
  }
  print(urlPath + ' returned 404');
  return File(basePath + '404.html');
}
