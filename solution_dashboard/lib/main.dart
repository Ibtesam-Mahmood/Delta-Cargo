import 'package:flutter/material.dart';
import 'dart:io';
import 'cargo.dart';
import 'widgets/titledwidget.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(AppDashBoard());

class AppDashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Delta Cargo Dashboard",
      theme: ThemeData(
        primaryColor: Color(0xFF03254E),
        textSelectionColor: Color(0xFF545677),
        accentColor: Color(0xFF545677)
      ),
      home: new Body(),

    );
  }
}

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  BodyState createState() {
    return new BodyState();
  }
}

class BodyState extends State<Body> {

  bool stolen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3B4975),
      body: DashBoard(stolen),
      appBar: AppBar(
        title: Image(image: AssetImage('lib/assets/dltacargo.png')),
        centerTitle: Platform.isIOS?true:false,
        actions: <Widget>[
          InkWell(child: Container(child: Icon(Icons.autorenew), margin: EdgeInsets.only(right: 20),)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        child: Icon(stolen?Icons.warning:Icons.local_shipping),
        backgroundColor: stolen?Color(0xFFCC0000):Color(0xFF0559BF),
        onPressed: (){stolen = !stolen; setState(() {});}
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class DashBoard extends StatefulWidget {

  DashBoard(this.stolenOnly);

  final bool stolenOnly;

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Cargo> cargoList = [];

  Icon _getTrailingIcon(String status){
    if(status=="Delivered") return Icon(Icons.card_giftcard, color: Colors.teal,);
    else if(status=="Delivering") return Icon(Icons.local_shipping, color: Colors.cyan);
    else return Icon(Icons.warning, color: Color(0xFFCC0000),);
  }

  //makes an API call for to the IEX stock api
  Future<void> fetchPost() async {
    //Parameters to the API call
    final response =
        await http.get("http://isaiah.localhost.run/getTrucks");

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      await _addCargo(response.body);
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

  //Takes a json and extracts the stock infromation and adds it to the list
  Future<void> _addCargo(String decoded){
    List<Cargo> addedList = getCargoListFromJson(decoded);
    cargoList = [];
    cargoList.addAll(addedList);
    setState(() {
      cargoList.sort((a,b) {return (a.status=="Stolen")?0:1;});
    }); //update widget
    return null;
  }

  Widget _listTimeBuilder(BuildContext context, int i){
    if(cargoList[i].status != "Stolen" && widget.stolenOnly) return null;
    else return Card(
      elevation: 3,
      child: ListTile(
        leading: TitledWidget(text: "Status", widget: _getTrailingIcon(cargoList[i].status),),
        title: Text("Next Departure:" + cargoList[i].nextDep.substring(0,5).toString()),
        subtitle: Text("ID: " + cargoList[i].id.toString()),
        trailing: TitledWidget(text: "Moving", widget: Icon(cargoList[i].getMoving()?Icons.forward:Icons.block)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();



    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 40),
      child: ListView.builder(
        itemCount: cargoList.length,
        itemBuilder: (context, i) => _listTimeBuilder(context, i),
      ),
    );
  }
}