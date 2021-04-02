import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_static/shelf_static.dart';
import 'constants.dart';
import 'jsonHelper.dart';

Router routes() {
  var app = Router();
  app.get('/', (_) => shelf.Response.found('/index.html'));
  app.get('/json/', jsonGetHandler);
  app.post('/json/', jsonPostHandler);
  app.get(
      '/<file>', createStaticHandler(basePath, defaultDocument: '404.html'));
  return app;
}
