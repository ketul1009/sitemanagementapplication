import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:multiselect/multiselect.dart';
import 'package:second_draft/AppPages/DailyReport/DailyReport.dart';
import 'package:second_draft/AppPages/DailyReport/DetailedReport.dart';
import 'package:second_draft/AppPages/HomePage.dart';
import 'package:second_draft/Common/CustomDrawer.dart';
import 'package:second_draft/Models/DailyReport.dart';
import 'package:http/http.dart' as http;
import '../LoginPage.dart';
import 'package:second_draft/main.dart';

Report selectedReport = Report("", "", "", GeneralInfo('', '', '', '', '', ''), EnvironmentInfo('','','',''), ManpowerInfo('','','','','','',''), "");
class ViewReportPage extends StatefulWidget{
  const ViewReportPage({super.key});

  @override
  State<ViewReportPage> createState() => ViewReportPageState();
}

class ViewReportPageState extends State<ViewReportPage>{

  String serverResponse='Server Response';
  List<Report> reports = [];
  bool drawerOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  int serialNo = 1;
  Set<String> business = {'All'};
  Set<String> subBusiness = {'All'};
  Set<String> location = {'All'};
  List<String> selectedBusiness = [];
  List<String> selectedSubBusiness = [];
  List<String> selectedLocation = [];

  void _fetchReports() async {
    setState(() {
      serialNo=1;
      isLoading = true;
    });
    final url = Uri.parse(
        "https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/dailyreport/siteincharge");
    List<Report> reportsTemp = [];
    try {
      final response = await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'preparedBy': user.userId})
      );
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        for(var value in data['Items']){
          business.add(value['business']);
          subBusiness.add(value['subBusiness']);
          location.add(value['location']);
          var sign = value['signedBy'] ?? "";
          GeneralInfo generalInfo = GeneralInfo(value['date'], value['business'], value['subBusiness'], value['location'], value['contractor'], value['supervisor']);
          EnvironmentInfo environmentInfo = EnvironmentInfo(value['weather'], value['temp'], value['wind'], value['humidity']);
          ManpowerInfo manpowerInfo = ManpowerInfo(value['skilled'], value['semiSkilled'], value['unskilled'], value['supervisors'], value['irrigationTech'], value['horticulturist'], value['managers']);
          reportsTemp.add(
            Report(value['preparedBy'], value['name'], value['reportId'], generalInfo, environmentInfo, manpowerInfo, sign)
          );
        }
        reportsTemp.sort((a, b) {
          return Comparable.compare(b.generalInfo.date, a.generalInfo.date);
        });
        setState(() {
          reports=reportsTemp;
        });
      }
      else{
        setState(() {
          serverResponse=response.body;
        });
      }
    }
    catch (e) {
      setState(() {
        serverResponse=e.toString();
      });
    }
    setState(() {
      isLoading=false;
    });
  }

  void _fetchReportsAdmin() async {
    setState(() {
      serialNo=1;
      isLoading = true;
    });
    final url = Uri.parse(
        "https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/dailyreport/admin");
    List<Report> reportsTemp = [];
    try {
      final response = await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'preparedBy': user.userId})
      );
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        for(var value in data['Items']){
          var sign = value['signedBy'] ?? "";
          business.add(value['business']);
          subBusiness.add(value['subBusiness']);
          location.add(value['location']);
          GeneralInfo generalInfo = GeneralInfo(value['date'], value['business'], value['subBusiness'],value['location'], value['contractor'], value['supervisor']);
          EnvironmentInfo environmentInfo = EnvironmentInfo(value['weather'], value['temp'], value['wind'], value['humidity']);
          ManpowerInfo manpowerInfo = ManpowerInfo(value['skilled'], value['semiSkilled'], value['unskilled'], value['supervisors'], value['irrigationTech'], value['horticulturist'], value['managers']);
          reportsTemp.add(
              Report(value['preparedBy'], value['name'], value['reportId'], generalInfo, environmentInfo, manpowerInfo, sign)
          );
        }
        reportsTemp.sort((a, b) {
          return Comparable.compare(b.generalInfo.date, a.generalInfo.date);
        });
        setState(() {
          reports=reportsTemp;
        });
      }
      else{
        setState(() {
          serverResponse=response.body;
        });
      }
    }
    catch (e) {
      setState(() {
        serverResponse=e.toString();
      });
    }
    setState(() {
      isLoading=false;
    });
  }

  void _fetchReportsSupervisor() async {
    setState(() {
      serialNo=1;
      isLoading = true;
    });
    final url = Uri.parse(
        "https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/dailyreport/admin");
    List<Report> reportsTemp = [];
    try {
      final response = await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'preparedBy': user.userId})
      );
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        for(var value in data['Items']){
          var sign = value['signedBy'] ?? "";
          business.add(value['business']);
          subBusiness.add(value['subBusiness']);
          location.add(value['location']);
          if(value['supervisor']==user.userId || value['preparedBy']==user.userId){
            GeneralInfo generalInfo = GeneralInfo(value['date'], value['business'], value['subBusiness'],value['location'], value['contractor'], value['supervisor']);
            EnvironmentInfo environmentInfo = EnvironmentInfo(value['weather'], value['temp'], value['wind'], value['humidity']);
            ManpowerInfo manpowerInfo = ManpowerInfo(value['skilled'], value['semiSkilled'], value['unskilled'], value['supervisors'], value['irrigationTech'], value['horticulturist'], value['managers']);
            reportsTemp.add(
                Report(value['preparedBy'], value['name'], value['reportId'], generalInfo, environmentInfo, manpowerInfo, sign)
            );
          }
        }
        reportsTemp.sort((a, b) {
          return Comparable.compare(b.generalInfo.date, a.generalInfo.date);
        });
        setState(() {
          reports=reportsTemp;
        });
      }
      else{
        setState(() {
          serverResponse=response.body;
        });
      }
    }
    catch (e) {
      setState(() {
        serverResponse=e.toString();
      });
    }
    setState(() {
      isLoading=false;
    });
  }

  void _verifyAndFetch() async {
    var isConnected = await InternetConnectionChecker().hasConnection;
    if (!isConnected) {
      setState(() {
        serverResponse="Please check your Internet";
      });
    }
    else{
      if(user.role=="admin"){
        _fetchReportsAdmin();
      }
      else if(user.role=="supervisor"){
        _fetchReportsSupervisor();
      }
      else{
        _fetchReports();
      }
    }
  }

  List<Report> filterData(List<String> selectedBusiness, List<String> selectedSubBusiness, List<String> selectedLocation) {
    setState(() {
      serialNo=1;
    });
    return reports.where((data) {
      final businessMatch = selectedBusiness.contains(data.generalInfo.business) || selectedBusiness.contains("All");
      final subBusinessMatch = selectedSubBusiness.contains(data.generalInfo.subBusiness) || selectedSubBusiness.contains("All");
      final locationMatch = selectedLocation.contains(data.generalInfo.location) || selectedLocation.contains("All");
      return businessMatch && subBusinessMatch && locationMatch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _verifyAndFetch();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(!drawerOpen) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
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
                      child: Text("Refresh"),
                    ),
                  ];
                },
                onSelected:(value) {
                  if (value == 0) {
                    _verifyAndFetch();
                  }
                }
            ),
          ],
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        drawer: Drawer(
          // Add your menu items inside the Drawer
          width: 400,
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
                    const Text('Select Business', style: TextStyle(fontSize: 15, color: Colors.black),),
                    Container(height: 10,),
                    DropDownMultiSelect(
                        options: business.toList(),
                        selectedValues: selectedBusiness,
                        onChanged: (value){
                          setState(() {
                            if(value.contains('All')){
                              selectedBusiness=business.toList();
                            }
                            selectedBusiness = value;
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
                    const Text('Select Sub-Business', style: TextStyle(fontSize: 15, color: Colors.black),),
                    Container(height: 10,),
                    DropDownMultiSelect(
                        options: subBusiness.toList(),
                        selectedValues: selectedSubBusiness,
                        onChanged: (value){
                          setState(() {
                            if(value.contains('All')){
                              selectedSubBusiness=subBusiness.toList();
                            }
                            selectedSubBusiness = value;
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
                    const Text('Select Location', style: TextStyle(fontSize: 15, color: Colors.black),),
                    Container(height: 10,),
                    DropDownMultiSelect(
                        options: location.toList(),
                        selectedValues: selectedLocation,
                        onChanged: (value){
                          setState(() {
                            if(value.contains('All')){
                              selectedLocation=location.toList();
                            }
                            selectedLocation = value;
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
                      reports=filterData(selectedBusiness, selectedSubBusiness, selectedLocation);
                    });
                    _scaffoldKey.currentState?.closeDrawer();
                  },
                ),
              )
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center, width: 200,
                  child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DailyReport())
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [Text("New Report", style: TextStyle(fontSize: 20 ,color: Colors.black),), Icon(Icons.add, color: Colors.black,)],)
                  ),)],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if(isLoading)
                  const CircularProgressIndicator(),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text("Sr. No", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Date", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Prepared By", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Supervisor", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)))
                  ],
                  rows: reports.map(
                          (reportRow) => DataRow(
                          onSelectChanged: (selected){
                            selectedReport=reportRow;
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>const DetailedReportPage())
                            );
                          },
                          cells: [
                            DataCell(
                              Text((serialNo++).toString()),
                              showEditIcon: false,
                              placeholder: false,
                            ),
                            DataCell(
                              Text(reportRow.generalInfo.date),
                              showEditIcon: false,
                              placeholder: false,
                            ),
                            DataCell(
                              Text(reportRow.preparedBy),
                              showEditIcon: false,
                              placeholder: false,
                            ),
                            DataCell(
                              Text(reportRow.generalInfo.supervisor),
                              showEditIcon: false,
                              placeholder: false,
                            )
                          ]
                      )
                  ).toList(),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}