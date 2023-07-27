import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:second_draft/AppPages/LoginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AppPages/HomePage.dart';
import 'Models/User.dart';

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

  runApp(
      WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: MaterialApp(
            theme: ThemeData(
                textTheme:  GoogleFonts.mavenProTextTheme()
            ),
            title: 'Home Page',
            home: const FormApp()))
  );
}
