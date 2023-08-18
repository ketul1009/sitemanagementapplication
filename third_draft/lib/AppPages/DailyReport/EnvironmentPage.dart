import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:second_draft/AppPages/DailyReport/ManpowerPage.dart';
import 'package:second_draft/Models/DailyReport.dart';

import 'DailyReportBusiness.dart';

class EnvironmentPage extends StatefulWidget{

  const EnvironmentPage({super.key});
  @override
  State<EnvironmentPage> createState() => EnvironmentPageState();
}

class EnvironmentPageState extends State<EnvironmentPage>{

  List<String> weather = [
    'Weather',
    'Sunny',
    'Rainy',
    'Overcast',
  ];
  List<String> wind = [
    'Wind',
    'Still',
    'Moderate',
    'High'
  ];
  List<String> humidity = [
    'Humidity',
    'Dry',
    'Moderate',
    'Humid'
  ];
  String selectedWeather = 'Weather';
  String selectedWind = "Wind";
  String selectedHumidity="Humidity";
  String temp = "";
  String response="";


  @override
  Widget build(BuildContext context) {
    ReportProvider reportProvider = context.watch<ReportProvider>();
    Report report = reportProvider.report;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DailyReportBusiness()));
        return true;
      },
      child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
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
                Container(height: 10,),
                const Text('Enter Temp (Celsius)', style: TextStyle(fontSize: 20, color: Colors.black),),
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
                      temp = newValue;
                    });
                  },
                ),
                ),
                Container(height: 10,),
                const Text('Select Wind', style: TextStyle(fontSize: 20, color: Colors.black),),
                Container(height: 10,),
                DropdownButton(
                  // Initial Value
                  value: selectedWind,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: wind.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedWind = newValue!;
                    });
                  },
                ),
                Container(height: 10,),
                const Text('Select Humidity', style: TextStyle(fontSize: 20, color: Colors.black),),
                Container(height: 10,),
                DropdownButton(
                  // Initial Value
                  value: selectedHumidity,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: humidity.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedHumidity = newValue!;
                    });
                  },
                ),
                Container(height: 10,),
                ElevatedButton(
                  onPressed: (){
                    if(selectedWeather=="Weather" || selectedWind=="Wind" || temp.isEmpty || selectedHumidity.isEmpty){
                      setState(() {
                        response="Please enter valid inputs";
                      });
                    }
                    else{
                      report.environmentInfo=EnvironmentInfo(selectedWeather, temp, selectedWind, selectedHumidity);
                      reportProvider.setReport(report);
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>const ManpowerPage())
                      );
                    }
                  },
                  child: Text('Next', style: TextStyle(fontSize: 20),),
                ),
                Text(response, style: const TextStyle(color: Colors.red),)
              ],
            ),
          ),
    ));
  }
}