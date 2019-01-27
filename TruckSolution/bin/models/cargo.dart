import 'dart:convert';
class Cargo {

  final int id;
  bool _moving;
  final String nextDep;
  final String status;

  Cargo(this.id, int moved, this.nextDep, this.status){
    _moving = moved>=1?true:false;
  }

  factory Cargo.fromJson(String json) {
    Map<String, dynamic> map;
    map = jsonDecode(json);
    return Cargo.fromMap(map);
  }

  factory Cargo.fromMap(Map<String, dynamic> map) {
    return new Cargo(map["id"], map["moving"], map["nextDep"], map["status"]);
  }

  Map<String, dynamic> getMap() {
    return {
      "id": id,
      "moving":  _moving,
      "nextDep":    nextDep,
      "status":   status
    };
  }

  String toJson() {
    Map<String, dynamic> map = getMap();
    return jsonEncode(map);
  }


  //returns true if the object is moving past the time indicated (stolen)
  //returns false if the object is in the state in which it should be
  bool getStolen(){
    return status=="Stolen"?true:false;
  }

  bool getMoving(){
    return _moving;
  }
}

Cargo fakeCargo = new Cargo(1, 1, "00:00:00", "Delivering");
Cargo stolenCargo = new Cargo(1, 1, "00:00:00", "Stolen");

List<Cargo> fakeCargos = [
  new Cargo(1, 1, "01:00:00", "Delivering"),
  new Cargo(2, 1, "10:00:00", "Delivering"),
  new Cargo(3, 1, "00:05:00", "Delivering"),
  new Cargo(4, 1, "00:00:00", "Delivering"),
  new Cargo(5, 1, "02:00:00", "Delivering"),
  new Cargo(6, 1, "00:00:00", "Delivering"),
  new Cargo(7, 1, "00:00:00", "Delivering"),
  new Cargo(8, 1, "00:00:00", "Delivering"),
  new Cargo(9, 1, "04:00:00", "Delivering"),
  new Cargo(10, 1, "00:00:00", "Delivering"),
  new Cargo(11, 1, "00:05:00", "Delivering"),
  new Cargo(12, 1, "00:00:00", "Delivering"),
  new Cargo(13, 1, "00:00:00", "Delivering"),
  new Cargo(14, 1, "3:00:00", "Delivering"),
  new Cargo(15, 1, "00:00:00", "Delivering"),
  new Cargo(16, 1, "0:00:00", "Delivering"),
  new Cargo(17, 1, "00:00:00", "Delivering")
];


String getFakeCargosJson() {
  return getJsonListFromCargoList(fakeCargos);
}


List<Cargo> getCargoListFromJson(String json) {
  List<Cargo> cargos = new List();
  List<dynamic> dynamicList = jsonDecode(json);
  for (String cargoJson in dynamicList)
    cargos.add(Cargo.fromJson(cargoJson));
  return cargos;
}

String getJsonListFromCargoList(List<Cargo> cargos) {
  List<String> strings = new List();
  for (Cargo cargo in cargos)
    strings.add(cargo.toJson());
  return jsonEncode(strings);
}