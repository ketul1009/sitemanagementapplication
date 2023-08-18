import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:second_draft/AppPages/HomePage.dart';
import 'package:second_draft/AppPages/LoginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/User.dart';

User user = User("userId", "password", "email", "name", "role");

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
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

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SharedPreferences prefs =await SharedPreferences.getInstance();
  var session=prefs.getBool("session");
  if(session==true) {
    user.userId = prefs.getString("userId")!;
    user.name = prefs.getString("name")!;
    user.email = prefs.getString("email")!;
    user.role = prefs.getString("role")!;
  }
  runApp(MaterialApp(
      theme: ThemeData(
        textTheme:  GoogleFonts.mavenProTextTheme()
      ),
      title: 'Home Page',
      home: session!=true ? const FormApp() : const HomePage())
  );
}
