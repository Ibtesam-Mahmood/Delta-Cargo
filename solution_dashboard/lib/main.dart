import 'package:flutter/material.dart';
import 'dart:io';
import 'cargo.dart';
import 'widgets/titledwidget.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

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
      home: Scaffold(
        backgroundColor: Color(0xFF3B4975),
        body: DashBoard(),
        appBar: AppBar(
          title: Image(image: AssetImage('lib/assets/cargo.jpg')),
          centerTitle: Platform.isIOS?true:false,
          actions: <Widget>[
            InkWell(child: Container(child: Icon(Icons.autorenew), margin: EdgeInsets.only(right: 20),)),
          ],
        ),
      ),

    );
  }
}

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final List<Cargo> cargoList = [Cargo(1, 1, "00:00:00", "Delivering"), Cargo(1, 0, "17:50:00", "Delivered"), Cargo(1, 1, "15:03:00", "Stolen")];

  Icon _getTrailingIcon(String status){
    if(status=="Delivered") return Icon(Icons.card_giftcard, color: Colors.teal,);
    else if(status=="Delivering") return Icon(Icons.local_shipping, color: Colors.cyan);
    else return Icon(Icons.warning, color: Color(0xFFCC0000),);
  }

  //makes an API call for to the IEX stock api
  Future<void> fetchPost() async {
    //Parameters to the API call
    final response =
        await http.get("http://isaiah.localhost.run/getTruck");

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      await _addCargo(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      print('Failed to load post');
    }
  }

  //Takes a json and extracts the stock infromation and adds it to the list
  Future<void> _addCargo(Map<String, dynamic> decoded){
    Cargo temp = new Cargo(
      decoded['id'],
      decoded['moving']==true?1:0,
      decoded['nextDep'],
      decoded['status']
    );
    cargoList.add(temp);
    setState(() {
      cargoList.sort((a,b) {return (a.status=="Stolen")?1:0;});
    }); //update widget
    return null;
  }

  Widget _listTimeBuilder(BuildContext context, int i){
    return Card(
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
      margin: EdgeInsets.only(top: 5),
      child: ListView.builder(
        itemCount: cargoList.length,
        itemBuilder: (context, i) => _listTimeBuilder(context, i),
      ),
    );
  }
}