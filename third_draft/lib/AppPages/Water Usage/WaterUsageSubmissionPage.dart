import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:second_draft/Common/DateAndTimePicker.dart';
import 'package:http/http.dart' as http;
import '../../Common/CustomDrawer.dart';
import '../../Models/WaterUsageRecord.dart';
import '../../main.dart';

class WaterUsageSubmissionPage extends StatefulWidget{

  const WaterUsageSubmissionPage({super.key});
  @override
  State<WaterUsageSubmissionPage> createState() => _WaterUsageSubmissionPageState();

}

class _WaterUsageSubmissionPageState extends State<WaterUsageSubmissionPage>{
  List<String> weather = [
    'Sunny',
    'Rainy',
    'Overcast',
  ];
  List<String> area = [
    'Indoor',
    'Outdoor',
  ];
  String selectedArea = 'Outdoor';
  String selectedWeather = 'Sunny';
  String waterUsage = '';
  String date="";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  bool error=false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Set the system overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make the status bar transparent
        statusBarIconBrightness: Brightness.dark, // Dark status bar icons
      ),
    );

    // Enable fullscreen mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    WaterRecordProvider waterRecordProvider = context.watch<WaterRecordProvider>();
    WaterUsageRecord waterUsageRecord = waterRecordProvider.greenDataRecord;
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
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
            child: Column(
              children: [
                DateAndTimePicker(
                  title: "Select Date",
                  onDataSubmission: (String temp){
                      setState(() {
                        date=temp;
                      });
                    }),
                const Text('Select Area', style: TextStyle(fontSize: 20, color: Colors.black),),
                Container(height: 10,),
                DropdownButton(
                  // Initial Value
                  value: selectedArea,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: area.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedArea = newValue!;
                    });
                  },
                ),
                Container(height: 30,),
                const Text('Select Weather', style: TextStyle(fontSize: 20, color: Colors.black),),
                Container(height: 10,),
                DropdownButton(
                  // Initial Value
                  value: selectedWeather,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: weather.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedWeather = newValue!;
                    });
                  },
                ),
                Container(height: 30,),
                const Text('Enter Water Usage (KL)', style: TextStyle(fontSize: 20, color: Colors.black),),
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
                      waterUsage = newValue;
                    });
                  },
                ),
                ),
                Container(height: 20,),
                ElevatedButton(
                  onPressed: (){
                    if(waterUsage.isEmpty){
                      showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text('Invalid value'),
                          content: const Text('Water usage cannot be empty'),
                          actions: <Widget>[
                            IconButton(onPressed: (){
                              Navigator.of(context).pop(false);
                            }, icon: const Icon(Icons.check))
                          ],
                        );
                      });
                    }
                    else{
                      _submitData(user.userId, waterUsageRecord.business, waterUsageRecord.subBusiness, waterUsageRecord.location, date, selectedArea, selectedWeather, waterUsage);
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

  _submitData(String userId, String business, String subBusiness, String location, String date, String area, String weather, String waterUsage) async {
    setState(() {
      isLoading = true;
    });
    String recordId = randomAlphaNumeric(6);
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/submit");
    try{
      var res = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(
            {'userId': user.userId,
              'recordId':recordId,
              'time' : DateTime.now().toString(),
              'business': business,
              'subBusiness':subBusiness,
              'location':location,
              'date':date,
              'area': area,
              'weather': weather,
              'waterUsage': waterUsage
            }),
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
