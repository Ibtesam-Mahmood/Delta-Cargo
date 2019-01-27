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
        accentColor: Color(0xFF545677)
      ),
      home: Scaffold(
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
  final List<Cargo> cargoList = [Cargo(1, 0, "00:00:00", "Delivered")];

  Icon _getTrailingIcon(String status){
    if(status=="Delivered") return Icon(Icons.card_giftcard, color: Colors.green,);
    else if(status=="Delivering") return Icon(Icons.local_shipping, color: Colors.teal);
    else return Icon(Icons.warning, color: Colors.red,);
  }

        //   title: Text(cargoList[i].nextDep.toString()),
        // subtitle: Text("ID: " + cargoList[i].id.toString()),
        // trailing: _getTrailingIcon(cargoList[i].status),

  Widget _listTimeBuilder(BuildContext context, int i){
    return Card(
      elevation: 3,
      child: ListTile(
        leading: TitledWidget(text: "Status", widget: _getTrailingIcon(cargoList[i].status),),
        title: Text("Next Departure:" + cargoList[i].nextDep.toString()),
        subtitle: Text("ID: " + cargoList[i].id.toString()),
        trailing: TitledWidget(text: "Moving", widget: Icon(cargoList[i].getMoving()?Icons.forward:Icons.block)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cargoList.length,
      itemBuilder: (context, i) => _listTimeBuilder(context, i),
    );
  }
}