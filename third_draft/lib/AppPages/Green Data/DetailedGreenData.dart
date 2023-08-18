import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:second_draft/AppPages/Green%20Data/ViewGreenData.dart';
import '../../Common/CustomDrawer.dart';
import '../../Models/GreenDataRecord.dart';
import '../LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:second_draft/main.dart';

class DetailedGreenData extends StatefulWidget{

  const DetailedGreenData({super.key});
  @override
  State<DetailedGreenData> createState() => DetailedGreenDataState();

}

class DetailedGreenDataState extends State<DetailedGreenData>{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  bool error=false;

  void _deleteReport() async {
    final url = Uri.parse(
        "https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/greendata/object/${user.userId}/${selectedRecord.reportId}");
    var response = await delete(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
    );
    debugPrint(response.body.toString());
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async {
        if(!drawerOpen) {
          Navigator.pop(context);
          return false;
        }
        else{
          setState(() {
            drawerOpen=false;
          });
          _scaffoldKey.currentState?.closeDrawer();
          return false;
        }
      },
      child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu, size: 50, color: Colors.black),
              onPressed: () {
                setState(() {
                  drawerOpen=true;
                });
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            actions: [
              PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black, size: 30,),
                  itemBuilder: (context){
                    return [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text("Delete"),
                      ),
                    ];
                  },
                  onSelected:(value) {
                    if (value == 0) {
                      showDialog(
                          context: context,
                          builder: (context)=> AlertDialog(
                            title: const Text("Are you sure?"),
                            content: const Text("This action is irreversible"),
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    _deleteReport();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context)=> const ViewGreenDataPage())
                                    );
                                  },
                                  child: const Text("Yes")),
                              TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("No")),
                            ],
                          )
                      );
                    }
                  }
              ),
            ],
            elevation: 2,
            backgroundColor: Colors.white,
          ),
          drawer: const CustomDrawer(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(10.0), // Border radius
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
                          child: Text("Business: ${selectedRecord.business}", style: const TextStyle(fontSize: 20, color: Colors.black),),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
                          child: Text("Sub-Business: ${selectedRecord.subBusiness}", style: const TextStyle(fontSize: 20, color: Colors.black),),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
                          child: Text("Location: ${selectedRecord.location}", style: const TextStyle(fontSize: 20, color: Colors.black),),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 600,
                  alignment: Alignment.topCenter,
                  child: Container(
                    alignment: Alignment.center,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: selectedRecord.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            child: SpeciesDisplay(
                                selectedRecord.data[index].type,
                                selectedRecord.data[index].species,
                                selectedRecord.data[index].quantity,
                                selectedRecord.data[index].area,
                                selectedRecord.data[index].date),
                          );
                        }
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}

class SpeciesDisplay extends StatelessWidget{
  final String type;
  final String species;
  final String quantity;
  final String area;
  final String date;

  const SpeciesDisplay(this.type, this.species, this.area, this.quantity, this.date, {super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(10.0), // Border radius
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
            child: Text("Type: $type", style: const TextStyle(fontSize: 20, color: Colors.black),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
            child: Text("Species: $species", style: const TextStyle(fontSize: 20, color: Colors.black),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
            child: Text("Quantity: $quantity", style: const TextStyle(fontSize: 20, color: Colors.black),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
            child: Text("Area: $area", style: const TextStyle(fontSize: 20, color: Colors.black),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
            child: Text("Date: $date", style: const TextStyle(fontSize: 20, color: Colors.black),),
          ),
        ],
      ),
    );
  }
}