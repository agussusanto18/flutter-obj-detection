import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:obj_detection/pages/Signin.dart';
import 'package:http/http.dart' as http;


class SignupPage extends StatefulWidget {
  @override
  _SignupState createState() => new _SignupState();
}

class _SignupState extends State<SignupPage> {
  bool isLoading = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  Future register() async{
    setState((){
      isLoading = true;
    });

    var url = Uri.parse("http://braille.api.tenji.id/signup.php");
    var response = await http.post(url, body: {
      "name": username.text,
      "password": password.text,
      "email": email.text
    });

    var data = json.decode(response.body);
    if(!data['error']) {
      clearFields();
      // show message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("registration is successful, please login to continue"), backgroundColor: Colors.greenAccent,));

      // Timing redirect to signin page
      Timer(Duration(seconds: 3), (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SigninPage()),
        );
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['error_msg']), backgroundColor: Colors.redAccent,));
    }

    setState((){
      isLoading = false;
    });
  }

  void clearFields() {
    username.clear();
    password.clear();
    email.clear();
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
                      Text("Signup", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),),
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
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'email',
                        ),
                      ),
                      SizedBox(height: 15,),
                      RaisedButton(
                          child: Text("Register"),
                          onPressed: () {
                            register();
                          }),

                      SizedBox(height: 65,),
                      Text("Have an account?", style: TextStyle(fontSize: 18),),
                      TextButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SigninPage()),
                          );
                        },
                        child: Text("Login", style: TextStyle(fontSize: 18),),
                      )
                    ],
                  ),
                )),

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
          ],
        )
    );
  }
}
