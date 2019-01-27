class Cargo{

  final int id;
  bool _moving;
  final String nextDep;
  final String status;

  Cargo(this.id, int moved, this.nextDep, this.status){
    _moving = moved>=1?true:false;
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