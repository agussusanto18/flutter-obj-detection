import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obj_detection/pages/Home.dart';
import 'package:obj_detection/pages/Signin.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    final preferences = await SharedPreferences.getInstance();
    setState((){
      isLogin = preferences.getBool("login") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (isLogin) ? MyHomePage() : SigninPage(),
    );
  }
}