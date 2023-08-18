import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:second_draft/AppPages/LoginPage.dart' as login;

import '../Common/CustomDrawer.dart';

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
          drawer: const CustomDrawer(),
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