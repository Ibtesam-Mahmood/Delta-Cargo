import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'models/cargo.dart';
import "models/logic.dart";
var _get = {
  "testTruck": _getTruck,
  "getTrucks": _getTrucks,
  "getStolenTruck":_getStolenTruck
};

var _post = {
  "setMove": _setMove
};

var _handlers = {
  "isaiah": _isaiah,
  "ibtesam": _ibtesam,
  "esha": _esha,

  "getTruck": _get["testTruck"],
  "getTrucks":_get["getTrucks"],
  "getStolenTruck":_get["getStolenTruck"],
  "setMove": _post["setMove"]
};

Map<String, String> jsonHeader = {
  'Content-type' : 'application/json',
  'Accept': 'application/json',
};

Map<String, String> setMoveErrorHeader = {
  "code": "21211",
  "message": "Missing Data for id or moving",
  "more_info": "ask Isaiah to make documents for the api",
  "status": "304"
};

shelf.Response _getTrucks(shelf.Request request){
  String json = getFakeCargosJson();
  return shelf.Response.ok(json, headers: jsonHeader);
}

shelf.Response _getStolenTruck(shelf.Request request){
  String json = stolenCargo.toJson();
  return shelf.Response.ok(json, headers: jsonHeader);
}

shelf.Response _getTruck(shelf.Request request){
  Map<String, String> parameters = request.url.queryParameters;
  String id = parameters["id"];

  if (id != null) {
    Cargo cargo = getCargoFromId(int.parse(id));
    if (cargo != null) {
      if (!isAllowedToMove(cargo)) {
        print("POSSIBLE THEFT!!!");
        possibleTheft.add(cargo);
        cargo.status = "Stolen";
      }
    }
  }

  String json = stolenCargo.toJson();
  return shelf.Response.ok(json, headers: jsonHeader);
}


Future<shelf.Response> _setMove(shelf.Request request) async {
  Map<String, String> parameters = request.url.queryParameters;
  String id = parameters["id"];
  String moveString = parameters["move"];// == "true";
  print("id = " + id + " moveString = " + moveString);
  if (id == null || moveString == null)
    return shelf.Response.notModified(headers: setMoveErrorHeader);

  bool moving = moveString == "true" || moveString == "1";
  Cargo cargo = getCargoFromId(int.parse(id));
  if (!isAllowedToMove(cargo) && moving) {
    print("POSSIBLE THEFT!!!");
    possibleTheft.add(cargo);
    cargo.status = "Stolen";
    cargo.moving = true;

  }
 getCargoFromId(int.parse(id));


  String msg  = ("setting cargo $id moving to $moving");
  print(msg);
  return shelf.Response.ok(msg);
}



shelf.Response _handler(shelf.Request request) {
  shelf.Response r = shelf.Response.ok(
      "Welcome to le app ;) plz enjoy <3",//File("bin/client.html").readAsStringSync(),
      headers: jsonHeader
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
//      .addMiddleware(shelf.logRequests())
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
