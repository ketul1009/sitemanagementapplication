import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:second_draft/AppPages/DailyReport/DailyReport.dart';
import 'package:second_draft/AppPages/DailyReport/DetailedReport.dart';
import 'package:second_draft/AppPages/HomePage.dart';
import 'package:second_draft/Models/Report.dart';
import 'package:http/http.dart' as http;
import '../LoginPage.dart';

Report selectedReport = Report("", "", "", GeneralInfo('', '', '', '', ''), EnvironmentInfo('','','',''), ManpowerInfo('','','','','','',''), '');
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

  void _fetchReports() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
        "https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/siteincharge");
    List<Report> reportsTemp = [];
    try {
      final response = await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'preparedBy': user.userId})
      );
      debugPrint(response.body);
      if(response.statusCode==200){
        debugPrint("Inside if");
        final data = jsonDecode(response.body);
        for(var value in data['Items']){
          GeneralInfo generalInfo = GeneralInfo(value['date'], value['company'], value['location'], value['contractor'], value['supervisor']);
          debugPrint("General Info done");
          EnvironmentInfo environmentInfo = EnvironmentInfo(value['weather'], value['temp'], value['wind'], value['humidity']);
          debugPrint("Env Info done");
          ManpowerInfo manpowerInfo = ManpowerInfo(value['skilled'], value['semiSkilled'], value['unskilled'], value['supervisors'], value['irrigationTech'], value['horticulturist'], value['managers']);
          debugPrint("Man Info done");
          reportsTemp.add(
            Report(value['preparedBy'], value['name'], value['reportId'], generalInfo, environmentInfo, manpowerInfo, "Signed By")
          );
          debugPrint("Report added");
        }
        setState(() {
          reports=reportsTemp;
        });
      }
      else{
        debugPrint("Inside Else");
        setState(() {
          serverResponse=response.body;
        });
      }
    }
    catch (e) {
      debugPrint("Inside Catch: "+e.toString());
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
      isLoading = true;
    });
    final url = Uri.parse(
        "https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/admin");
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
          GeneralInfo generalInfo = GeneralInfo(value['date'], value['company'], value['location'], value['contractor'], value['supervisor']);
          EnvironmentInfo environmentInfo = EnvironmentInfo(value['weather'], value['temp'], value['wind'], value['humidity']);
          ManpowerInfo manpowerInfo = ManpowerInfo(value['skilled'], value['semiSkilled'], value['unskilled'], value['supervisors'], value['irrigationTech'], value['horticulturist'], value['manager']);
          reportsTemp.add(
              Report(value['preparedBy'], value['name'], value['reportId'], generalInfo, environmentInfo, manpowerInfo, "Signed By")
          );
        }
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
      else{
        _fetchReports();
      }
    }
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
            icon: Icon(Icons.menu, size: 50, color: Colors.black),
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
          child: ListView(
            children: [
              Container(
                  decoration: const BoxDecoration(color: Colors.blue),
                  height: 100,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.settings)
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Text("Welcome "+user.name+", "+user.email)
                      ),
                    ],
                  )
              ),
              ListTile(
                title: Text('Feature 1'),
                onTap: () {
                  // Handle item 1 tap
                },
              ),
              ListTile(
                title: Text('Feature 2'),
                onTap: () {
                  // Handle item 2 tap
                },
              ),
              // Add more items as needed
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
                    DataColumn(label: Text("Date")),
                    DataColumn(label: Text("Prepared By")),
                    DataColumn(label: Text("Supervisor"))
                  ],
                  rows: reports.map(
                          (reportRow) => DataRow(
                          onSelectChanged: (selected){
                            selectedReport=reportRow;
                            debugPrint(selectedReport.name);
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>const DetailedReportPage())
                            );
                          },
                          cells: [
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