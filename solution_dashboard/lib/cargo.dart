import 'dart:convert';
class Cargo{

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
    return new Cargo(map["id"], map["moving"]?1:0, map["nextDep"], map["status"]);
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
