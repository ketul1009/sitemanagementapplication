import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:random_string/random_string.dart';
import '../LoginPage.dart';


class SubmissionPage extends StatefulWidget{

  const SubmissionPage({super.key});
  @override
  State<SubmissionPage> createState() => _SubmissionPageState();

}

class _SubmissionPageState extends State<SubmissionPage>{

  List<String> airports = [
    'BOM',
    'IXE',
    'JAI',
    'LKO',
    'AMD',
    'TRV',
    'GAU',
    'NBOM',
  ];
  List<String> locations = [
    'Indoor',
    'Outdoor',
  ];
  List<String> weather = [
    'Sunny',
    'Rainy',
    'Overcast',
  ];
  String selectedCompany = 'BOM';
  String selectedLocation = 'Outdoor';
  String selectedWeather = 'Sunny';
  String waterUsage = '';
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.fromDateTime(DateTime.now());
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  bool error=false;

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
                  TextButton(
                    onPressed: () async {
                      _selectDate(context);
                      _selectTime(context);
                    },
                    child: Text("${date.toString().split(' ')[0]} ${time.hourOfPeriod}:${time.minute} ${time.period.name.toUpperCase()}",
                      style: const TextStyle(color: Colors.black,
                          fontSize: 20
                      ),
                    ),
                  ),
                  Container(height: 10,),
                  const Text('Select Airport', style: TextStyle(fontSize: 20, color: Colors.black),),
                  Container(height: 10,),
                  DropdownButton(
                    // Initial Value
                    value: selectedCompany,
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
                        selectedCompany = newValue!;
                      });
                    },
                  ),
                  Container(height: 30,),
                  const Text('Select Location', style: TextStyle(fontSize: 20, color: Colors.black),),
                  Container(height: 10,),
                  DropdownButton(
                    // Initial Value
                    value: selectedLocation,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: locations.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLocation = newValue!;
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
                        String formattedDateTime = "${date.toString().split(' ')[0]} ${time.hourOfPeriod}:${time.minute} ${time.period.name.toUpperCase()}";
                        _submitData(formattedDateTime,selectedCompany, selectedLocation, selectedWeather, waterUsage);
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

  _submitData(String date, String company, String location, String weather, String waterUsage) async {
    setState(() {
      isLoading = true;
    });
    String recordId = randomAlphaNumeric(6);
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/submit");
    try{
      var res = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({'recordId':recordId ,'userId': user.userId, 'company': company, 'location':location, 'date':date, 'weather':weather, 'waterUsage': waterUsage}),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: time,
    );

    if (pickedTime != null && pickedTime != time) {
      setState(() {
        time = pickedTime;
      });
    }
  }

  @override
  void dispose() {
    // Reset system overlay settings
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

}
