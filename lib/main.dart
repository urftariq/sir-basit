import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mwff/Product/product_fetch.dart';
import 'package:flutter_mwff/firebase_options.dart';
import 'package:flutter_mwff/login_screen.dart';
import 'package:flutter_mwff/tabview_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TabViewScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future getUser()async{
    SharedPreferences userCred = await SharedPreferences.getInstance();
    return userCred.getString("userEmail");
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser().then((value) {
      if(value !=null ){
        Timer(const Duration(milliseconds: 2000), () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DashBoardScreen(),)),);
      }
      else{
        Timer(const Duration(milliseconds: 2000), () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),)),);
      }
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}



