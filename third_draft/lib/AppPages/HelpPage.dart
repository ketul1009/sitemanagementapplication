import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:second_draft/AppPages/LoginPage.dart' as login;

class HelpPage extends StatelessWidget{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool drawerOpen = false;

  @override
  Widget build(BuildContext context){
    return WillPopScope(
        onWillPop: () async {
          if(!drawerOpen) {
            Navigator.pop(context);
            return false;
          }
          else{
            /*setState(() {
              drawerOpen=false;
            });*/
            _scaffoldKey.currentState?.closeDrawer();
            return false;
          }
        },
        child: MaterialApp(
      title: 'Help',
      home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu, size: 50, color: Colors.black),
              onPressed: () {
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
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Container(
                    child: IconButton(
                      icon: Icon(Icons.settings,),
                      onPressed: (){

                      },
                    ),
                  ),
                  height: 100,
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
              Container(height: 50,),
              Container(
                height: 100,
                child: Column(
                  children: [
                    Text(
                      'Contact: 8141XXXXXXX',
                        style: TextStyle(fontSize: 20),),
                    Container(height: 20,),
                    Text('Email: xyz@adani.com',
                        style: TextStyle(fontSize: 20),),
                  ],
                ),
              )
            ]
          ),
        ),
    )
    );
  }
}