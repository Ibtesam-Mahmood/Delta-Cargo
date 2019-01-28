import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:numberpicker/numberpicker.dart';
import 'dart:convert';
import 'cargo.dart';

void main() => runApp(ClientApp());

class ClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Delta Cargo Truck",
      theme: ThemeData(
        primaryColor: Color(0xFF03254E),
        textSelectionColor: Color(0xFF545677),
        accentColor: Color(0xFF545677)
      ),
      home: Scaffold(
        backgroundColor: Color(0xFF3B4975),
        appBar: AppBar(
          title: Text("Truck"),
          centerTitle: Platform.isIOS?true:false,
        ),
        body: LayoutWidget(),
      ),
      
    );
  }
}

class LayoutWidget extends StatefulWidget {

  @override
  LayoutWidgetState createState() {
    return new LayoutWidgetState();
  }
}

class LayoutWidgetState extends State<LayoutWidget> {
  int id = 1;
  String timeToDeparture = "00:00";

  Future<void> _setMove() async{
    await http.get('http://isaiah.localhost.run/setMove?id=${id}&move=true');
  }

  Future<void> fetchPost() async {
    //Parameters to the API call
    final response =
        await http.get("http://isaiah.localhost.run/getTrucks");


    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      timeToDeparture = getCargoListFromJson(response.body)[id-1].nextDep;
      setState(() {});
    } else {
      // If that response was not OK, throw an error.
      print('Failed to load post');
    }
  }

  List<Cargo> getCargoListFromJson(String json) {
    List<Cargo> cargos = new List();
    List<dynamic> dynamicList = jsonDecode(json);
    for (String cargoJson in dynamicList)
      cargos.add(Cargo.fromJson(cargoJson));
    return cargos;
  }

  @override
  void initState() {
    super.initState();

    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("ID", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40)),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: NumberPicker.integer(
                infiniteLoop: true,
                initialValue: 1,
                minValue: 1,
                maxValue: 17,
                onChanged: (newValue) =>setState((){
                  if(newValue != null){
                    id = newValue;
                    fetchPost();
                  }
                })
              ),
            ),
            RaisedButton(child: Text("Move Trailer " + (id).toString()), onPressed: (){_setMove();},),
            Padding(padding: EdgeInsets.all(10),),
            Text("Next Departure At: ${timeToDeparture.substring(0,5)}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
