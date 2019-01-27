class Cargo{

  final int id;
  final bool moving;
  DateTime _nextDep;
  final String status;

  Cargo(this.id, this.moving, String date, this.status){
    this._nextDep = DateTime.parse("2019-01-27 " + date);
  }

  //returns true if the object is moving past the time indicated (stolen)
  //returns false if the object is in the state in which it should be
  bool getStolen(){
    return status=="Stolen"?true:false;
  }

}