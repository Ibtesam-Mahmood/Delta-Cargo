import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

var _handlers = {
  "isaiah": _isaiah,
  "ibtesam": _ibtesam,
  "esha": _esha
};

var _get = {
  "truck": _getTruck,
};

shelf.Response _getTruck(shelf.Request request){
  final client = File("bin/client.html").readAsStringSync();

  return shelf.Response.ok(client);
}

//
//shelf.Response _handler(shelf.Request request) =>
//    shelf.Response.ok('welcome - :)');


Map<String, String> headers = {
  'Content-type' : 'application/json',
  'Accept': 'application/json',
};

shelf.Response _handler(shelf.Request request) {

  shelf.Response r = shelf.Response.ok(
      "{wow:'wow'}",//File("bin/client.html").readAsStringSync(),
      headers: headers
  );

  return r;

}




Middleware middle = (homeHandler) {
      //Handler - function takes request returns futureor<t> response
      return (request) {

        var handler;
        if (request.url.pathSegments.length > 0) {
          handler = _handlers[request.url.pathSegments.first];
          if (handler == null) handler = _pathNotFound;
        } else {
          handler = homeHandler;
        }

        return Future.sync(() => handler(request)).then((response){return response;}, onError: (error, StackTrace stackTrace) {
          if (error is HijackException) throw error;

          var msg = "rip";
          print("[Error]" + msg);

          throw error;
        });
      };

};

main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p', defaultsTo: '8080');

  var result = parser.parse(args);

  var port = int.tryParse(result['port']);

  if (port == null) {
    stdout.writeln(
        'Could not parse port value "${result['port']}" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware(middle)
      .addHandler(_handler);

  var server = await io.serve(handler, 'localhost', port);
  print('Serving at http://${server.address.host}:${server.port}');
}

shelf.Response _pathNotFound(shelf.Request request) =>
    shelf.Response.ok('path not found');


shelf.Response _isaiah(shelf.Request request) =>
    shelf.Response.ok('Isaiah: made the backend logic');


shelf.Response _ibtesam(shelf.Request request) =>
    shelf.Response.ok('Ibtesam: codeded thee flutter');


shelf.Response _esha(shelf.Request request) =>
    shelf.Response.ok('Esha: did created the datebase and the db handler');
