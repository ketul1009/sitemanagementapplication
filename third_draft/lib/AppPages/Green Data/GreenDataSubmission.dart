import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';

import '../LoginPage.dart';

class GreenDataSubmissionPage extends StatefulWidget{
  const GreenDataSubmissionPage({super.key});

  @override
  State<GreenDataSubmissionPage> createState() => GreenDataSubmissionPageState();

}

class GreenDataSubmissionPageState extends State<GreenDataSubmissionPage>{

  List<String> airports = [
    'Airport',
    'BOM',
    'IXE',
    'JAI',
    'LKO',
    'AMD',
    'TRV',
    'GAU',
    'NBOM',
  ];
  List<String> months = [
    'Month',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  String selectedAirport="Airport";
  String selectedMonth="Month";
  String trees="";
  String shrubs="";
  String lawn="";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  bool error=false;

  @override
  Widget build(BuildContext context) {
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
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        drawer: Drawer(
          // Add your menu items inside the Drawer
          child: ListView(
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.blue),
                height: 100,
                child: IconButton(
                  icon: const Icon(Icons.settings,),
                  onPressed: (){

                  },
                ),
              ),
              ListTile(
                title: const Text('Feature 1'),
                onTap: () {
                  // Handle item 1 tap
                },
              ),
              ListTile(
                title: const Text('Feature 2'),
                onTap: () {
                  // Handle item 2 tap
                },
              ),
              // Add more items as needed
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 40,),
                const Text('Select Airport', style: TextStyle(fontSize: 20, color: Colors.black),),
                Container(height: 10,),
                DropdownButton(
                  // Initial Value
                  value: selectedAirport,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: airports.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAirport = newValue!;
                    });
                  },
                ),
                Container(height: 30,),
                const Text('Select Month', style: TextStyle(fontSize: 20, color: Colors.black),),
                Container(height: 10,),
                DropdownButton(
                  // Initial Value
                  value: selectedMonth,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: months.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMonth = newValue!;
                    });
                  },
                ),
                Container(height: 30,),
                const Text('Enter number of Trees', style: TextStyle(fontSize: 20, color: Colors.black),),
                SizedBox( width: 150, child: TextField(
                  maxLength: 10,
                  cursorHeight: 30,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (String newValue){
                    setState(() {
                      trees = newValue;
                    });
                  },
                ),
                ),
                Container(height: 20,),
                const Text('Enter Shrubs and Green Cover (Sq. Mt)', style: TextStyle(fontSize: 20, color: Colors.black),),
                SizedBox( width: 150, child: TextField(
                  maxLength: 10,
                  cursorHeight: 30,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (String newValue){
                    setState(() {
                      shrubs = newValue;
                    });
                  },
                ),
                ),
                Container(height: 20,),
                const Text('Enter Lawn area (Sq. Mt)', style: TextStyle(fontSize: 20, color: Colors.black),),
                SizedBox( width: 150, child: TextField(
                  maxLength: 10,
                  cursorHeight: 30,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (String newValue){
                    setState(() {
                      lawn = newValue;
                    });
                  },
                ),
                ),
                ElevatedButton(
                  onPressed: (){
                    if(selectedMonth=="Month" || selectedAirport=="Airport" || shrubs.isEmpty || lawn.isEmpty || trees.isEmpty){
                      showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text('Invalid input'),
                          content: const Text('Please enter valid Input'),
                          actions: <Widget>[
                            IconButton(onPressed: (){
                              Navigator.of(context).pop(false);
                            }, icon: const Icon(Icons.check))
                          ],
                        );
                      });
                    }
                    else{
                      String formattedDateTime = DateTime.now().toString();
                      _submitData(formattedDateTime, selectedAirport, selectedMonth, trees, shrubs, lawn);
                      if(!error){
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: const Text('Successful'),
                            content: const Text('Your submission is recorded'),
                            actions: <Widget>[
                              IconButton(onPressed: (){
                                Navigator.of(context).pop(false);
                                Navigator.of(context).pop(false);
                              }, icon: const Icon(Icons.check))
                            ],
                          );
                        });
                      }
                      else{
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: const Text('Submission Failed'),
                            content: const Text('Some internal error occurred'),
                            actions: <Widget>[
                              IconButton(onPressed: (){
                                Navigator.of(context).pop(false);
                              }, icon: const Icon(Icons.check))
                            ],
                          );
                        });
                      }
                    }
                  },
                  child: const Text('Submit', style: TextStyle(fontSize: 20),),
                ),
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