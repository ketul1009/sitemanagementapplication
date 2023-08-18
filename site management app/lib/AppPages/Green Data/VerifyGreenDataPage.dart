import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:second_draft/AppPages/Green%20Data/ViewGreenData.dart';
import '../../Common/CustomDrawer.dart';
import '../../Models/GreenDataRecord.dart';
import '../HomePage.dart';
import '../LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:second_draft/main.dart';

class VerifyGreenDataPage extends StatefulWidget{

  const VerifyGreenDataPage({super.key});
  @override
  State<VerifyGreenDataPage> createState() => VerifyGreenDataPageState();

}

class VerifyGreenDataPageState extends State<VerifyGreenDataPage>{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  bool error=false;
  String alert = "";

   void _submitData(GreenDataRecord greenDataRecord) async {
    setState(() {
      error=false;
    });
    List<Map<String, String>> data = [];
    for(var species in greenDataRecord.data){
      data.add({
        "greenZone": species.greenZone,
        "type": species.type,
        "species": species.species,
        "quantity" : species.quantity,
        "area" : species.area,
        "date" : species.date
      });
    }
    String recordId = randomAlphaNumeric(6);
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/submit/greendata/");
    var payLoad = {
      'time': DateTime.now().toString(),
      'recordId':recordId ,
      'userId': user.userId,
      'business': greenDataRecord.business,
      'subBusiness': greenDataRecord.subBusiness,
      'location': greenDataRecord.location,
      'greenZone': "GreenZone number",
      'data': data};

    try{
      var res = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(payLoad));
      debugPrint(res.body);
      if(res.statusCode!=200){
        setState(() {
          error=true;
        });
      }
    }
    catch(err){
      setState(() {
        error=true;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    GreenDataProvider greenDataProvider = context.watch<GreenDataProvider>();
    GreenDataRecord greenDataRecord = greenDataProvider.greenDataRecord;
    return WillPopScope(
      onWillPop: () async {
        if(!drawerOpen) {
          Navigator.of(context).pop();
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
            elevation: 2,
            backgroundColor: Colors.white,
          ),
          drawer: const CustomDrawer(),
          persistentFooterButtons: [
            Column(
              children: [
                Text(alert, style: const TextStyle(color: Colors.red),),
                Row(
                mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if(greenDataRecord.data.isEmpty){
                          setState(() {
                            alert="*No data has been entered";
                          });
                        }
                        else{
                         _submitData(greenDataProvider.greenDataRecord);
                          if(!error){
                            showDialog(
                                context: context,
                                builder: (context)=> AlertDialog(
                                  title: const Text("Submitted Successfully"),
                                  content: const Text("Your report is submitted"),
                                  actions: [
                                    TextButton(
                                        onPressed: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context)=> const ViewGreenDataPage())
                                          );
                                        },
                                        child: const Text("View all reports")),
                                    TextButton(
                                        onPressed: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context)=> const HomePage())
                                          );
                                        },
                                        child: const Text("Go to home")),
                                  ],
                                )
                            );
                          }
                          debugPrint(greenDataRecord.business);
                          debugPrint(greenDataRecord.subBusiness);
                          debugPrint(greenDataRecord.location);
                        }
                      },
                      child: const Text("Submit"))
                ],
              )
              ],
            )
          ],
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
                          child: Text("Business: ${greenDataRecord.business}", style: const TextStyle(fontSize: 20, color: Colors.black),),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
                          child: Text("Sub-Business: ${greenDataRecord.subBusiness}", style: const TextStyle(fontSize: 20, color: Colors.black),),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
                          child: Text("Location: ${greenDataRecord.location}", style: const TextStyle(fontSize: 20, color: Colors.black),),
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
                        itemCount: greenDataRecord.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            child: SpeciesDisplay(
                                greenDataRecord.data[index].greenZone,
                                greenDataRecord.data[index].type,
                                greenDataRecord.data[index].species,
                                greenDataRecord.data[index].quantity,
                                greenDataRecord.data[index].area,
                                greenDataRecord.data[index].date),
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
  final String greenZone;
  final String type;
  final String species;
  final String quantity;
  final String area;
  final String date;

  const SpeciesDisplay(this.greenZone, this.type, this.species, this.quantity, this.area, this.date, {super.key});

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
            child: Text("GreenZone: $greenZone", style: const TextStyle(fontSize: 20, color: Colors.black),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
            child: Text("Type: $type", style: const TextStyle(fontSize: 20, color: Colors.black),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
            child: Text("Name: $species", style: const TextStyle(fontSize: 20, color: Colors.black),),
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