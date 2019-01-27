import 'package:flutter/material.dart';
import 'dart:io';
import 'cargo.dart';
import 'widgets/titledwidget.dart';

void main() => runApp(AppDashBoard());

class AppDashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Solution",
      theme: ThemeData(
        primaryColor: Color(0xFF03254E),
        textSelectionColor: Color(0xFF545677),
        accentColor: Color(0xFF545677)
      ),
      home: Scaffold(
        backgroundColor: Color(0xFF3B4975),
        body: DashBoard(),
        appBar: AppBar(
          title: Text("Cargo Dashboard"),
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

        //   title: Text(cargoList[i].nextDep.toString()),
        // subtitle: Text("ID: " + cargoList[i].id.toString()),
        // trailing: _getTrailingIcon(cargoList[i].status),

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