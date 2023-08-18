import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class CustomDrawer extends StatefulWidget{

  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer>{

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        children: [
          Container(
              decoration: const BoxDecoration(color: Colors.blue),
              height: 100,
              child: Column(
                children: [
                  const SizedBox(
                      height: 30,
                  ),
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: Text("Welcome ${user.name}, ${user.email}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                  ),
                ],
              )
          ),
          ListTile(
            title: const Text(''),
            onTap: () {
              // Handle item 1 tap
            },
          ),
          ListTile(
            title: const Text(''),
            onTap: () {
              // Handle item 2 tap
            },
          ),
          // Add more items as needed
        ],
      ),
    );
  }
}