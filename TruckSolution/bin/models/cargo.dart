import 'dart:convert';
class Cargo {

  final int id;
  bool moving;
  final String nextDep;
  String status;

  Cargo(this.id, int moved, this.nextDep, this.status){
    moving = moved>=1?true:false;
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
      "moving":  moving,
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
    return moving;
  }
}

Cargo fakeCargo = new Cargo(1, 1, "00:00:00", "Delivering");
Cargo stolenCargo = new Cargo(1, 1, "00:00:00", "Stolen");

List<Cargo> fakeCargos = [
  new Cargo(001,0,'19:05:00','Delivered'),
  new Cargo(002,0,'17:30:24','Delivered'),
  new Cargo(003,1,'00:00:00','Delivering'),
  new Cargo(004,0,'20:45:00','Delivered'),
  new Cargo(005,1,'00:00:00','Delivering'),
  new Cargo(006,1,'00:00:00','Delivering'),
  new Cargo(007,0,'14:56:32','Delivered'),
  new Cargo(008,1,'00:00:00','Delivering'),
  new Cargo(009,1,'00:00:00','Delivering'),
  new Cargo(010,0,'06:00:00','Delivered'),
  new Cargo(011,1,'00:00:00','Delivering'),
  new Cargo(012,0,'22:07:00','Delivered'),
  new Cargo(013,0,'19:00:03','Delivered'),
  new Cargo(014,1,'00:00:00','Delivering'),
  new Cargo(015,1,'00:00:00','Delivering'),
  new Cargo(016,0,'23:09:33','Delivered'),
  new Cargo(017,1,'00:00:00','Delivering')
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