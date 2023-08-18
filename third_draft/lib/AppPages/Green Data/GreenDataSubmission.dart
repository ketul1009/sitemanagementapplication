import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:second_draft/Common/DateAndTimePicker.dart';
import 'package:second_draft/Common/TreeSpeciesDialog.dart';
import 'package:second_draft/Models/GreenDataRecord.dart';
import '../../Common/CustomDrawer.dart';
import '../LoginPage.dart';
import 'VerifyGreenDataPage.dart';
import 'package:second_draft/main.dart';

class GreenDataSubmissionPage extends StatefulWidget{
  const GreenDataSubmissionPage({super.key});

  @override
  State<GreenDataSubmissionPage> createState() => GreenDataSubmissionPageState();

}

class GreenDataSubmissionPageState extends State<GreenDataSubmissionPage>{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  bool error=false;
  String alert="";

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){
                    if(greenDataRecord.data.isEmpty){
                      setState(() {
                        alert="*Please select appropriate input";
                      });
                    }
                    else{
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VerifyGreenDataPage())
                      );
                    }
                  },
                  child: const Text("Verify"))
            ],
          )
        ],
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 40,),
                const SizedBox(height: 7.5,),
                TreeSpeciesDialog(
                    onDataSubmitted: (Map<String, String> map){
                      greenDataRecord.data.add(SpeciesData(map["GreenZone"]! ,map["Type"]!, map["Species"]!, map["Quantity"]!, map["Area"]!, map["Date"]!));
                      greenDataProvider.setReport(greenDataRecord);
                      Fluttertoast.showToast(msg: "Successfully added Species", backgroundColor: Colors.green);
                    }
                ),
                const SizedBox(height: 7.5,),
                Text(alert, style: const TextStyle(color: Colors.red),),
              ],
            )
        ),
      ),
    );
  }

  _submitData(String time, String company, String month, String trees, String shrubs, String lawn) async {
    setState(() {
      error=false;
    });
    String recordId = randomAlphaNumeric(6);
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/submit/greendata/");
    try{
      var res = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({
          'recordId':recordId ,
          'userId': user.userId,
          'company': company,
          'month':month,
          'time':time,
          'trees':trees,
          'shrubs': shrubs,
          'lawn': lawn}),
      );
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

}