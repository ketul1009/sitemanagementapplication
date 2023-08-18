import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_draft/Models/GreenDataRecord.dart';

import '../../Constants/GeneralData.dart';

class BusinessSelector extends StatefulWidget{
  final void Function(Map<String, String> data) onDataSubmitted;

  BusinessSelector({super.key, required this.onDataSubmitted});

  @override
  State<BusinessSelector> createState() => BusinessSelectorState();

}

class BusinessSelectorState extends State<BusinessSelector>{

  List<String> businesses = ['Business'] + business.keys.toList();
  List<String> subBusinesses = ['Sub-Business'] + subBusiness['Business'];
  List<String> locations = ['Location'];
  String selectedBusiness = "Business";
  String selectedSubBusiness = "Sub-Business";
  String selectedLocation = "Location";
  String alert="";

  void _sendDataToParent(Map<String, String> data){
    widget.onDataSubmitted(data);
  }

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [const Text('Select Business', style: TextStyle(fontSize: 20, color: Colors.black),),
        Container(height: 10,),
        DropdownButton(
          // Initial Value
          value: selectedBusiness,
          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),
          // Array list of items
          items: businesses.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (newValue) {
            _selectedBusiness(newValue!);
          },
        ),
        Container(height: 30,),
        const Text('Select Sub Business', style: TextStyle(fontSize: 20, color: Colors.black),),
        Container(height: 10,),
        DropdownButton(
          // Initial Value
          value: selectedSubBusiness,
          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),
          // Array list of items
          items:subBusinesses.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              _selectedSubBusiness(newValue!);
            });
          },
        ),
        Container(height: 10,),
        const Text('Select Location', style: TextStyle(fontSize: 20, color: Colors.black),),
        Container(height: 10,),
        DropdownButton(
          // Initial Value
          value: selectedLocation,
          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),
          // Array list of items
          items:locations.map((String items) {
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
        Container(height: 10,),
        Text(alert, style: TextStyle(color: Colors.red),),
        Container(height: 10,),
        ElevatedButton(
            onPressed: (){
              if(selectedBusiness=="Business" || selectedSubBusiness=="Sub-Business" || selectedLocation=="Location"){
                setState(() {
                  alert="*Please select appropriate input";
                });
              }
              else{
                Map<String, String> data = {
                  'selectedBusiness' : selectedBusiness,
                  'selectedSubBusiness' : selectedSubBusiness,
                  'selectedLocation' : selectedLocation
                };
                _sendDataToParent(data);
              }
            },
            child: const Text("Next"))
      ],
    );
  }

  void _selectedBusiness(String newValue){
    setState(() {
      selectedBusiness = newValue;
      selectedSubBusiness = "Sub-Business";
      subBusinesses = ["Sub-Business"];
      subBusinesses = List.from(subBusinesses)..addAll(business[newValue]);
    });
  }

  void _selectedSubBusiness(String newValue){
    setState(() {
      selectedSubBusiness = newValue;
      selectedLocation = "Location";
      locations = ["Location"];
      locations = List.from(locations)..addAll(subBusiness[newValue]);
    });
  }
}