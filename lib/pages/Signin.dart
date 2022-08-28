import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obj_detection/pages/Home.dart';
import 'dart:convert';
import 'package:obj_detection/pages/Signup.dart';
import 'package:http/http.dart' as http;
import 'package:obj_detection/utils/ApiServices.dart';
import 'package:obj_detection/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SigninPage extends StatefulWidget {
  @override
  State<SigninPage> createState() => _SigninState();
}

class _SigninState extends State<SigninPage> {
  ApiServices apiServices;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    apiServices = ApiServices();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  Future login() async{
    setState((){
      isLoading = true;
    });

    await apiServices.login(username.text, password.text, onSuccess: (data){
      int userId = int.parse(data["data"]["user"]["id"]);
      String userName = data["data"]["user"]["name"];
      // set sessions
      setSession(userId, userName);

      // show message
      showSnackBar(context, "Login is successful", Colors.greenAccent);
      // Timing redirect to home page
      Timer(Duration(seconds: 2), (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage()),
        );
      });
    }, onError: (message){
      showSnackBar(context, message, Colors.redAccent);
    });

    setState((){
      isLoading = false;
    });
  }

  setSession(int userId, String userName) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool("login", true);
    await preferences.setInt("userId", userId);
    await preferences.setString("userName", userName);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
          children: [
            Positioned(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Signin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),),
                      SizedBox(height: 35,),
                      TextField(
                        controller: username,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'username',
                        ),
                      ),
                      SizedBox(height: 15,),
                      TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'password',
                        ),
                      ),
                      SizedBox(height: 15,),
                      RaisedButton(
                          child: Text("Login"),
                          onPressed: login),
                      SizedBox(height: 65,),
                      Text("don't have an account yet?", style: TextStyle(fontSize: 18),),
                      TextButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()),
                          );
                        },
                        child: Text("Register", style: TextStyle(fontSize: 18),),
                      )
                    ],
                  ),
                )
            ),

            Positioned(
                child: (isLoading) ? Container(
                  width: screenWidth,
                  height: screenHeight,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                        strokeWidth: 5,
                      ),
                    ),
                  ),
                ) : Text("")),
          ])
    );
  }
}
