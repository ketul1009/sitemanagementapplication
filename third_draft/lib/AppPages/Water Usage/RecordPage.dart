import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:multiselect/multiselect.dart';
import '../../Models/WaterUsageRecord.dart';
import '../LoginPage.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {

  bool isLoading = false;
  List<WaterUsageRecord> _documents = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  DataTableSource _data = RecordData([]);
  bool _sortAscending = true;
  Set<String> companies = {'All'};
  Set<String> locations = {'All'};
  Set<String> weathers = {'All'};
  List<String> selectedCompanies = [];
  List<String> selectedLocations = [];
  List<String> selectedWeathers = [];

  Future<void> fetchDocuments() async {
    setState(() {
      isLoading=true;
    });
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/records");
    try {
      List<WaterUsageRecord> documents = [];
      final response = await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'userId':user.userId})
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (var value in data['Items']){
          var temp = value;
          companies.add(temp['company']);
          locations.add(temp['location']);
          weathers.add(temp['weather']);
          documents.add(
              WaterUsageRecord(
                  temp['userId'],
                  temp['company'],
                  temp['date'],
                  temp['location'],
                  temp['weather'],
                  temp['waterUsage'])
          );
        }

        setState(() {
          _documents=documents;
        });
      }
      else {
      }
    } catch (e) {

    }
    setState(() {
      isLoading=false;
      _data=RecordData(_documents);
    });
  }

  void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _sortAscending = ascending;

      _documents.sort((a, b) {
        final aValue = _getValue(a, columnIndex);
        final bValue = _getValue(b, columnIndex);
        final comparison = ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
        return comparison;
      });
      setState(() {
        _data=RecordData(_documents);
      });
    });
  }

  List<WaterUsageRecord> filterData(List<String> selectedCompanies, List<String> selectedLocations, List<String> selectedWeathers) {
    setState(() {
    });
    return _documents.where((data) {
      final companyMatch = selectedCompanies.contains(data.company) || selectedCompanies.contains("All");
      final locationMatch = selectedLocations.contains(data.location) || selectedLocations.contains("All");
      final weatherMatch = selectedWeathers.contains(data.weather) || selectedWeathers.contains("All");
      return companyMatch && locationMatch && weatherMatch;
    }).toList();
  }

  dynamic _getValue(WaterUsageRecord document, int columnIndex) {
    switch (columnIndex) {
      case 0:
        return document.company;
      case 1:
        return document.date;
      case 2:
        return document.location;
      case 3:
        return document.weather;
      case 4:
        return document.waterUsage;
      default:
        return null;
    }
  }

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

    fetchDocuments();
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
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu, size: 30, color: Colors.black),
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
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.blue,
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(20),
                  child: const Text("Welcome", style: TextStyle(fontSize: 20),),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('Select Airport', style: TextStyle(fontSize: 20, color: Colors.black),),
                      Container(height: 10,),
                      DropDownMultiSelect(
                          options: companies.toList(),
                          selectedValues: selectedCompanies,
                          onChanged: (value){
                            setState(() {
                              if(value.contains('All')){
                                selectedCompanies=companies.toList();
                              }
                              selectedCompanies = value;
                            });
                          }
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('Select Location', style: TextStyle(fontSize: 20, color: Colors.black),),
                      Container(height: 10,),
                      DropDownMultiSelect(
                          options: locations.toList(),
                          selectedValues: selectedLocations,
                          onChanged: (value){
                            setState(() {
                              if(value.contains('All')){
                                selectedLocations=locations.toList();
                              }
                              selectedLocations = value;
                            });
                          }
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('Select Weather', style: TextStyle(fontSize: 20, color: Colors.black),),
                      Container(height: 10,),
                      DropDownMultiSelect(
                          options: weathers.toList(),
                          selectedValues: selectedWeathers,
                          onChanged: (value){
                            setState(() {
                              if(value.contains('All')){
                                selectedWeathers=weathers.toList();
                              }
                              selectedWeathers = value;
                            });
                          }
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    child: const Text("Submit"),
                    onPressed: (){
                      setState(() {
                        _data=RecordData(filterData(selectedCompanies, selectedLocations, selectedWeathers));
                      });
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                  ),
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 10,),
                    ElevatedButton(
                                onPressed: (){
                                  fetchDocuments();
                                },
                                style: const ButtonStyle(),
                                child: SizedBox(
                                    width: 150,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('Get Records', style: TextStyle(fontSize: 16 , color: Colors.black),),
                                          const Icon(Icons.autorenew_rounded, color: Colors.black,),
                                        ])
                                ),
                              ),
                    Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if(isLoading)
                                    const CircularProgressIndicator()
                                ],
                              ),
                    PaginatedDataTable(
                                      columns: [
                                        DataColumn(
                                          label: const Text('Company'),
                                          onSort: (columnIndex, ascending){
                                            setState(() {
                                              _sortAscending=!_sortAscending;
                                            });
                                            _sortData(0, _sortAscending);
                                          }
                                        ),
                                        DataColumn(
                                          label: const Text('Date'),
                                          onSort: (columnIndex, ascending){
                                            setState(() {
                                              _sortAscending=!_sortAscending;
                                            });
                                            _sortData(1, _sortAscending);
                                          }
                                        ),
                                        DataColumn(
                                          label: const Text('Location'),
                                          onSort: (columnIndex, ascending){
                                            setState(() {
                                              _sortAscending=!_sortAscending;
                                            });
                                            _sortData(2, _sortAscending);
                                          }
                                        ),
                                        DataColumn(
                                          label: const Text('Weather'),
                                          onSort: (columnIndex, ascending){
                                            setState(() {
                                              _sortAscending=!_sortAscending;
                                            });
                                            _sortData(3, _sortAscending);
                                          }
                                        ),
                                        DataColumn(
                                          label: const Text('Water Usage'),
                                          onSort: (columnIndex, ascending){
                                            setState(() {
                                              _sortAscending=!_sortAscending;
                                            });
                                            _sortData(4, _sortAscending);
                                          }
                                        ),
                                      ],
                                      source: _data,
                                    )
                  ]
          )
          ),
        ),
    );
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

class RecordData extends DataTableSource{

  List<Map<String, dynamic>> _data = List.generate(
      1,
          (index) => {
        "Company": "Company",
        "Date": "Date",
        "Location": "Location",
        "Weather":"Weather",
        "Water Usage": "Water Usage"
      });

  RecordData(List<WaterUsageRecord> temp){
    _data = List.generate(
        temp.length,
            (index) => {
          "Company": temp[index].company,
          "Date": temp[index].date,
          "Location": temp[index].location,
          "Weather": temp[index].weather,
          "Water Usage": temp[index].waterUsage
        });
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]["Company"])),
      DataCell(Text(_data[index]['Date'].toString())),
      DataCell(Text(_data[index]["Location"])),
      DataCell(Text(_data[index]['Weather'])),
      DataCell(Text(_data[index]["Water Usage"].toString())),
    ]);
  }
}