import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_draft/AppPages/DailyReport/DailyReport.dart';
import 'package:second_draft/AppPages/DailyReport/ViewReportPage.dart';
import 'package:second_draft/AppPages/Green%20Data/ViewGreenData.dart';
import 'package:second_draft/AppPages/MillionTrees/ViewTreesData.dart';
import 'package:second_draft/AppPages/Water%20Usage/RecordPage.dart';
import 'package:second_draft/AppPages/HelpPage.dart';
import 'package:flutter/services.dart';
import 'package:second_draft/AppPages/LoginPage.dart';
import 'package:second_draft/Common/Button.dart';
import 'package:second_draft/Models/Report.dart';
import '../Components/GradientButton.dart';
import 'Water Usage/SubmissionPage.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage>{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;

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
    return ChangeNotifierProvider(
        create: (context) => ReportProvider(Report("", "", "", GeneralInfo('', '', '', '', ''), EnvironmentInfo('','','',''), ManpowerInfo('','','','','','',''), '')),
        child: WillPopScope(
          onWillPop: () async {
            if(!drawerOpen) {
              return await showDialog(
                context: context,
                builder: (BuildContext builder) {
                  return AlertDialog(
                    title: const Text("Exit App"),
                    content: const Text("Are you sure?"),
                    actions: <Widget>[
                      CloseButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          SystemNavigator.pop(animated: true);
                        },
                      ),
                    ],
                  );
                },
              );
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
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.all(10),
                            child: const Icon(Icons.settings)
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text("Welcome "+user.name+", "+user.email)
                          ),
                        ],
                      )
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
                  child: Container(
                      color: Colors.white54,
                      child: Column(
                        children: [
                          Image.asset('assets/images/logo.png',
                          height: 140,),
                          Container(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(width: 350, height: 50, child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            MyElevatedButton(
                                                onPressed: (){
                                                  Navigator.push(
                                                      context, MaterialPageRoute(builder: (context) => const SubmissionPage())
                                                  );
                                                },
                                                gradient: const LinearGradient(colors: [Colors.blue, Colors.pink]),
                                                borderRadius: BorderRadius.circular(20),
                                                width: 150,
                                                child: SizedBox(
                                                  width: 150,
                                                  child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: const [
                                                          Text("New Water", style: TextStyle(fontSize: 16, color: Colors.white),),
                                                          Text("Usage Record", style: TextStyle(fontSize: 15, color: Colors.white),),
                                                        ],
                                                      )
                                                  ),
                                                )
                                            ),
                                            MyElevatedButton(
                                                onPressed: (){
                                                  Navigator.push(
                                                      context, MaterialPageRoute(builder: (context) => const DailyReport())
                                                  );
                                                },
                                                gradient: const LinearGradient(colors: [Colors.blue, Colors.pink]),
                                                borderRadius: BorderRadius.circular(20),
                                                width: 150,
                                                child: SizedBox(
                                                  width: 150,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: const [
                                                        Text("New Daily", style: TextStyle(fontSize: 16, color: Colors.white),),
                                                        Text("Report ", style: TextStyle(fontSize: 15, color: Colors.white),),
                                                      ],
                                                    )
                                                  ),
                                                )
                                            )
                                          ],
                                        ),)
                                      ],
                                    ),
                                    Container(height: 30,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(width: 350, height: 50, child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            MyElevatedButton(
                                                onPressed: (){
                                                  Navigator.push(
                                                      context, MaterialPageRoute(builder: (context) => const RecordPage())
                                                  );
                                                },
                                                gradient: const LinearGradient(colors: [Colors.blue, Colors.pink]),
                                                borderRadius: BorderRadius.circular(20),
                                                width: 150,
                                                child: SizedBox(
                                                  width: 150,
                                                  child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: const [
                                                          Text("Water Usage", style: TextStyle(fontSize: 16, color: Colors.white),),
                                                          Text("Records ", style: TextStyle(fontSize: 15, color: Colors.white),),
                                                        ],
                                                      )
                                                  ),
                                                )
                                            ),
                                            Button().createButton(context, 'Daily Reports', const ViewReportPage()),
                                          ],
                                        ),
                                        )
                                      ],
                                    ),
                                    Container(height: 30,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(width: 350, height: 50, child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            MyElevatedButton(
                                                onPressed: (){
                                                  Navigator.push(
                                                      context, MaterialPageRoute(builder: (context) => const ViewGreenDataPage())
                                                  );
                                                },
                                                gradient: const LinearGradient(colors: [Colors.blue, Colors.pink]),
                                                borderRadius: BorderRadius.circular(20),
                                                width: 150,
                                                child: SizedBox(
                                                  width: 150,
                                                  child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: const [
                                                          Text("Green Data", style: TextStyle(fontSize: 16, color: Colors.white),),
                                                          Text("Records", style: TextStyle(fontSize: 15, color: Colors.white),),
                                                        ],
                                                      )
                                                  ),
                                                )
                                            ),
                                            MyElevatedButton(
                                                onPressed: (){
                                                  Navigator.push(
                                                      context, MaterialPageRoute(builder: (context) => ViewTreesDataPage())
                                                  );
                                                },
                                                gradient: const LinearGradient(colors: [Colors.blue, Colors.pink]),
                                                borderRadius: BorderRadius.circular(20),
                                                width: 150,
                                                child: SizedBox(
                                                  width: 150,
                                                  child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: const [
                                                          Text("100 Million", style: TextStyle(fontSize: 16, color: Colors.white),),
                                                          Text("Mission", style: TextStyle(fontSize: 15, color: Colors.white),),
                                                        ],
                                                      )
                                                  ),
                                                )
                                            )
                                          ],
                                        ),)
                                      ],
                                    ),
                                    Container(height: 30,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(width: 350, height: 50, child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Button().createButton(context, 'Log Out', const FormApp()),
                                            Button().createButton(context, 'Help', HelpPage()),
                                          ],
                                        ),
                                        )
                                      ],
                                    ),
                                  ],
                              ),
                            ),
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.bottomCenter,
                                padding: const EdgeInsets.all(5),
                                child: const Text("Corporate Agri Sustainability", style: TextStyle(fontSize: 20),),
                              ),
                            ],
                          )
                        ],
                      ),
                  )
              )
          )
        )
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
