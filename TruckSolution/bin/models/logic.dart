import 'dart:convert';
import 'dart:io';
import "cargo.dart";

Cargo findId(int id) {
  for (Cargo cargo in fakeCargos) {
    if (cargo.id == id) {
      return cargo;
    }
  }
  return null;
}

Cargo getCargoFromId(int id) {
  Cargo cargo = findId(id);
  print("get from id = " + cargo.toJson());
  return cargo;
}

DateTime getDateTime(String time) {
  return DateTime.parse("2019-01-27 "+time);
}

bool isAllowedToMove(Cargo cargo) {
//  return DateTime.now(). isAfter(getDateTime(cargo.nextDep));
  bool allowed = DateTime.now().difference(getDateTime(cargo.nextDep)).abs() < Duration(minutes: 30);
  if (!allowed) sendMsg(phoneNumber: "16474705455", cargoId: cargo.id.toString());
  return allowed;
}

List<Cargo> possibleTheft = [];

String endPoint = "mediquix.lib.id";

void sendMsg({String phoneNumber, String cargoId}) {
  var json = {"number":phoneNumber, "id":cargoId};

  String req = "?number=" + phoneNumber + "&id="+cargoId;
  message(json);
}

//makes an API call for to the IEX stock api
Future<void> message(Map<String, String> data) async {

  HttpClient().postUrl(await new Uri.http(endPoint, "/deltacargo@dev/", data));
//  Uri.parse("https://mediquix.lib.id/deltacargo@dev/").
//  //Parameters to the API call
//  final response =
//  await http.get("http://isaiah.localhost.run/getTrucks");
//
//  if (response.statusCode == 200) {
//    // If server returns an OK response, parse the JSON
//    await _addCargo(response.body);
//  } else {
//    // If that response was not OK, throw an error.
//    print('Failed to load post');
//  }
}


//Future message(String path, String json) async {
////////  HttpClientRequest request = await HttpClient().post(_host, 4049, path) /*1*/
////////    ..headers.contentType = ContentType.json /*2*/
////////    ..write(jsonEncode(json)); /*3*/
////////  HttpClientResponse response = await request.close(); /*4*/
////////  await response.transform(utf8.decoder /*5*/).forEach(print);
////////}

//class UserClient extends http.BaseClient {
//  final String tenant;
//  final http.Client _httpClient;
//  final responseType = "id_token";
//  final scope = "openid";
//  final clientId = "6612ac25-1231-4f75-a557-6e0c90e8c217";
//  final redirect = "localhost:8080/";
//
//  UserClient(this._httpClient, this.tenant);
//
////
////  Future<StreamedResponse> send(BaseRequest request) {
//////    request.headers['user-agent'] = tentant;
////    return httpClient.send("request");
////  }
//}