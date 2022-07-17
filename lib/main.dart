import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obj_detection/pages/Home.dart';
import 'package:obj_detection/pages/Signin.dart';
import 'package:obj_detection/utils/ApiServices.dart';
import 'package:obj_detection/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  bool isLogin = true;
  String startDateTime;
  ApiServices apiServices;


  @override
  void initState() {
    super.initState();
    apiServices = ApiServices();
    checkLoginStatus();

    setState((){
      startDateTime = getCurrentDateStr();
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.inactive){
      recordDuration(getCurrentDateStr());
    } else if (state == AppLifecycleState.resumed) {
      setState((){
        startDateTime = getCurrentDateStr();
      });
    }
  }


  Future recordDuration(String endDateTime) async{
    final preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("userId");

    await apiServices.duration(startDateTime, endDateTime, "Home",  userId.toString(), onSuccess: (data){}, onError: (message){
      showSnackBar(context, "Failed to record duration", Colors.redAccent);
    });
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