// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_draft/AppPages/HomePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:second_draft/Models/User.dart';
import 'package:second_draft/Components/GradientButton.dart';
import 'package:riverpod/riverpod.dart' as rp;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:second_draft/main.dart';

class FormApp extends StatefulWidget{
  const FormApp({super.key});

  @override
  State<FormApp> createState() => _FormAppState();
}

class _FormAppState extends State<FormApp> {

  bool obsText = true;
  String userId = '';
  String password = '';
  String serverResponse = "";
  bool verified = false;
  bool isLoading = false;
  bool key=false;
  final container = rp.ProviderContainer();
  final userProvider = ChangeNotifierProvider<UserProvider>(create : (_) => UserProvider());
  var clientTime;
  var serverTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(height: 50,
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(child: Image.asset('assets/images/logo.png',
                    height: 140,),
                  ),
                  Container(
                    child: Column(
                      children: const [
                        Text("Site Management", style: TextStyle(fontSize: 30),),
                        Text("App",style: TextStyle(fontSize: 30),),
                      ],
                    )
                  ),
                  Container(
                      height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: const Text('Login',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Container(height: 20,),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("User ID", style: TextStyle(fontSize: 20),),
                            Container(
                              width: 250,
                              child: TextField(
                                cursorHeight: 30,
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                onChanged: (String newValue) {
                                  userId = newValue;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(height: 30,),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Password", style: TextStyle(fontSize: 20),),
                            Container(
                              width: 250,
                              child: TextField(
                                cursorHeight: 30,
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                onChanged: (String newValue) {
                                  password = newValue;
                                },
                                obscureText: obsText,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(obsText ? Icons.visibility : Icons
                                          .visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          obsText = !obsText;
                                        });
                                      },
                                    )
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(height: 10,),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if(isLoading)
                              const CircularProgressIndicator(),
                            Container(height: 10,),
                            MyElevatedButton(
                              onPressed: () async {
                                clientTime=DateTime.now();
                                if(userId.isNotEmpty && password.isNotEmpty){
                                  user.userId=userId;
                                  _login(context);
                                }
                                else{
                                  setState(() {
                                    serverResponse = "Please enter UserID and Password";
                                  });
                                }
                              },
                              gradient: const LinearGradient(colors: [Colors.blue, Colors.pink]),
                              borderRadius: BorderRadius.circular(20),
                              width: 100,
                              child: const Text('Login', style: TextStyle(fontSize: 20, color: Colors.white70),),
                            )
                          ],
                      ),
                      ),
                      Container(height: 30,),
                      Container(
                        child: Text(serverResponse,
                            style: const TextStyle(color: Colors.red)
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(5),
                        child: const Text("Corporate Agri Sustainability", style: TextStyle(fontSize: 20),),
                      ),
                    ],
                  ),
                ],
              ),
            )
        );
  }

  void _login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
        "https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/login");
    try {
      var res = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({'userId': userId, 'password': password}),
      ).timeout(const Duration(seconds: 15));
      var response = jsonDecode(res.body);
      debugPrint(res.body);
      if (res.body!="false"){
        SharedPreferences pref =await SharedPreferences.getInstance();
        pref.setString("userId", response['userId']);
        pref.setString("name", response['name']);
        pref.setString("email", response['email']);
        pref.setString("role", response['role']);
        pref.setBool("session", true);
        user.userId=response['userId'];
        user.name=response['name'];
        user.email=response['email'];
        user.role=response['role'];
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage())
        );
      }
      else if (res.body == 'false') {
        setState(() {
          isLoading = false;
          serverResponse = "*Incorrect User ID or Password";
        });
      }
    }
    catch (error) {
      if (error is TimeoutException) {
        setState(() {
          serverResponse = "Connection Timeout. Check your internet connection";
          isLoading = false;
        });
      }
      else {
        debugPrint(error.toString());
        setState(() {
          isLoading=false;
          serverResponse = "Some internal Error occurred";
        });
      }
    }
  }
}
