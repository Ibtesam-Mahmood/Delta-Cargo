import "cargo.dart";


Cargo getCargoFromId(int id) {
  return fakeCargos[id];
}

DateTime getDateTime(String time) {
  return DateTime.parse("2019-01-27 "+time);
}

bool isAllowedToMove(Cargo cargo) {
  return DateTime.now().isAfter(getDateTime(cargo.nextDep));
}