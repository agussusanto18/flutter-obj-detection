// import 'dart:ffi';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:obj_detection/enums.dart';
import 'package:obj_detection/pages/components/ResultOverlay.dart';
import 'package:obj_detection/pages/components/ResultText.dart';
import 'package:obj_detection/utils/Strings.dart';
import 'package:obj_detection/utils/constants.dart';
import 'package:obj_detection/utils/functions.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';

import '../utils/ApiServices.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final FlutterTts tts = FlutterTts();
  List<CameraDescription> cameras;
  List _recognitions;
  final String _model = yolo;
  double _imageHeight;
  double _imageWidth;
  CameraImage img;
  CameraController controller;
  bool isBusy = false;
  String result = "";
  bool selection = false;
  bool visible = false;
  String detectedClass = "";
  PageName pageName = PageName.home;
  bool topConfirm = false;
  bool bottomConfirm = false;
  ApiServices apiServices;
  bool isLoading = false;
  String startDateTime;
  bool swipeStatus = false;
  String usernameStr = "";
  int resultCounter = 0;

  @override
  void initState() {
    super.initState();
    apiServices = ApiServices();
    startDateTime = getCurrentDateStr();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Load model and initialize camera
    loadModel(_model);
    initCamera();

    // Initialize shake detector
    shakeDetectorHandling();
  }

  void shakeDetectorHandling() async {
    final preferences = await SharedPreferences.getInstance();
    String username = preferences.getString("userName") ?? "user";
    bool homeFirstStart = preferences.getBool("homeFirstStart") ?? true;
    bool islogin = preferences.getBool("login") ?? false;

    setState(() {
      usernameStr = username;
    });

    Timer(const Duration(seconds: 2), () {
      if (homeFirstStart && islogin) {
        speak(SpeechText.home4shake(username)).then((e) {
          preferences.setBool("homeFirstStart", false);
        });
      }
    });

    ShakeDetector detector2 = ShakeDetector.autoStart(
      onPhoneShake: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Shake!')));

        if (pageName == PageName.home) {
          speak(SpeechText.home2shake());
        } else if (pageName == PageName.result) {
          switch(detectedClass) {
            case "0":
              speak(SpeechText.resultShakeClass0(username));
              break;
            case "1":
              speak(SpeechText.resultShakeClass1(username));
              break;
            case "2":
              speak(SpeechText.resultShakeClass2(username));
              break;
            case "3":
              speak(SpeechText.resultShakeClass3(username));
              break;
            case "4":
              speak(SpeechText.resultShakeClass4(username));
              break;
            default:
              speak(SpeechText.result2shake(username));
              break;
          }
        }
      },
      minimumShakeCount: 2,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive) {
      recordDuration();
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        startDateTime = getCurrentDateStr();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.stopImageStream();
    Tflite.close();
  }

  initCamera() async {
    cameras = await availableCameras();

    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        controller.startImageStream((image) => {
              if (!isBusy) {isBusy = true, img = image, runModelOnFrame()}
            });
      });
    });
  }

  Future processFrame() async {
    await startObjectDetectionUsingYolo();
  }

  runModelOnFrame() async {
    _imageWidth = img.width + 0.0;
    _imageHeight = img.height + 0.0;
    _recognitions = await Tflite.detectObjectOnFrame(
      bytesList: img.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      model: _model == yolo ? "YOLO" : "SSDMobileNet",
      imageHeight: img.height,
      imageWidth: img.width,
      imageMean: _model == yolo ? 0 : 127.5,
      imageStd: _model == yolo ? 255.0 : 127.5,
      numResultsPerClass: 1,
      threshold: _model == yolo ? 0.2 : 0.4,
    );
    print(_recognitions.length);
    isBusy = false;
    setState(() {
      img;
    });
  }

  startObjectDetectionUsingYolo() async {
    if (img != null) {
      {
        _imageWidth = img.width + 0.0;
        _imageHeight = img.height + 0.0;
        _recognitions = await Tflite.detectObjectOnFrame(
          bytesList: img.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: img.height,
          imageWidth: img.width,
          imageMean: 0.0,
          imageStd: 255.0,
          model: "YOLO",
          threshold: 0.2,
          // defaults to 0.1
        );
        isBusy = false;
      }
      setState(() {
        img;
      });
    }
  }

  Future recordDuration() async {
    final preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("userId");

    await apiServices.duration(
        startDateTime, getCurrentDateStr(), "Result", userId.toString(),
        onSuccess: (data) {}, onError: (message) {
      showSnackBar(context, "Failed to record duration", Colors.redAccent);
    });
  }

  void showBackdrop(String detectedClass) async {
    final preferences = await SharedPreferences.getInstance();
    String username = preferences.getString("userName") ?? "user";
    bool resultFirstStart = preferences.getBool("resultFirstStart") ?? true;

    if (resultFirstStart) {
      speak(SpeechText.result4shake(username)).then((value) {
        preferences.setBool("resultFirstStart", false);
      });
    }

    try {
      setState(() {
        visible = true;
        pageName = PageName.result;
        controller.pausePreview();
        startDateTime = getCurrentDateStr();

        speak("This is pattern " + detectedClass.toString());
      });
    } catch (e) {
      print(e);
    }

    countCapture(detectedClass.toString());
  }

  void hideBackdrop() {
    if (visible) {
      recordDuration();
    }

    setState(() {
      visible = false;
      topConfirm = false;
      pageName = PageName.home;
      controller.resumePreview();
      resultCounter = 0;
    });
  }

  Future countCapture(String result) async {
    final preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("userId");
    await apiServices.capture(result, userId.toString(), onSuccess: (data) {},
        onError: (message) {
      showSnackBar(context, "Failed to record capture", Colors.redAccent);
    });
  }

  Future countAction(String type) async {
    setState(() {
      isLoading = true;
    });
    final preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("userId");
    await apiServices.count(type, userId.toString(), onSuccess: (data) {},
        onError: (message) {
      showSnackBar(context, "Failed to count action", Colors.redAccent);
    });
    setState(() {
      isLoading = false;
    });
  }

  Future wrongAnswer(String detectedClass) async {
    setState(() {
      isLoading = true;
    });

    await apiServices.wrongAnswer(detectedClass, onSuccess: (data) {
      Timer(const Duration(seconds: 3), () {
        speak(data);
      });
    }, onError: (message) {
      showSnackBar(context, message, Colors.redAccent);
    });

    setState(() {
      isLoading = false;
    });
  }

  Future speak(String obj) async {
    showVibration(context);
    await tts.setLanguage("en-US");
    await tts.speak(obj);
  }

  void detectedClassesCondition(String detectedClass){
    switch(detectedClass){
      case "0":
        speak("There are 3 full braille");
        break;
      case "1":
        speak("There are 4 braille written. The order is a full braille, an A braille, a full braille and an A braille");
        break;
      case "2":
        speak("There are 4 braille written. A full braille, a B braille, a full braille and a B braille");
        break;
      case "3":
        speak("There are 4 braille. A full braille, a dot number 3 braille, a full braille and a dot number 3 braille");
        break;
      case "4":
        speak("There are 4 braille. A full braille, an L braille, a full braille, and an L braille");
        break;
    }
  }

  void speechResult(String detectedClass){
    showBackdrop(detectedClass);

    Timer(const Duration(seconds: 3), () {
      detectedClassesCondition(detectedClass);
    });
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageHeight == null || _imageWidth == null) return [];
    double factorX = screen.width;
    double factorY = _imageHeight; // _imageWidth * screen.width;
    Color blue = const Color.fromRGBO(37, 213, 253, 1.0);
    return _recognitions.map((re) {

      if (re["confidenceInClass"] * 100 > 50) {
        if (resultCounter < 1) {
          setState(() {
            resultCounter = resultCounter + 1;
            detectedClass = re["detectedClass"];
            speechResult(re["detectedClass"]);
          });
        }
      }

      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: blue,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.red,
              fontSize: 15.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    //--------------- Camera Preview in Home Page ---------------
    stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        height: size.height,
        child: Container(
          height: size.height,
          child: (!controller.value.isInitialized)
              ? Container()
              : AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller),
                ),
        )));

    if (img != null) {
      stackChildren.addAll(renderBoxes(size));
    }

    //--------------- Result Page Overlay ---------------
    stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        height: size.height,
        child: Visibility(
            visible: visible,
            child: SwipeDetector(
              onSwipeUp: () {
                if (topConfirm) {
                  hideBackdrop();
                  speak("Thank you");
                } else {
                  speak(AppText.swipeUpConfirm)
                      .then((val) {
                    setState(() {
                      topConfirm = true;
                      bottomConfirm = false;
                    });
                  });
                }
                countAction("swipe_top");
              },
              onSwipeDown: () {
                if (bottomConfirm) {
                  speak(AppText.swipeDownFinal)
                      .then((val) {

                    wrongAnswer(detectedClass).then((value) {
                      setState(() {
                        bottomConfirm = false;
                      });
                    });
                  });
                } else {
                  speak(AppText.swipeDownConfirm)
                      .then((val) {
                    setState(() {
                      bottomConfirm = true;
                      topConfirm = false;
                    });
                  });
                }
                countAction("swipe_bottom");
              },
              onSwipeLeft: () {
                setState(() {
                  speak("This is pattern " + detectedClass);
                  Timer(const Duration(seconds: 3), () {
                    detectedClassesCondition(detectedClass);
                  });
                  countAction("swipe_left");
                });
              },
              onSwipeRight: () {
                setState(() {
                  hideBackdrop();
                  countAction("swipe_right");
                });
              },
              child: ResultOverlay(
                  detectedClass: detectedClass
              ),
            ))));

    //--------------- Progress bar indicator ---------------
    stackChildren.add(Positioned(
        child: (isLoading)
            ? Container(
                width: screenWidth,
                height: screenHeight,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: const CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 5,
                    ),
                  ),
                ),
              )
            : Container()));

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onLongPress: () {
            if (pageName == PageName.home) {
              speak(SpeechText.home4shake(usernameStr));
            } else if (pageName == PageName.result) {
              speak(SpeechText.result4shake(usernameStr));
            }
          },
          child: Container(
              color: Colors.black,
              child: Stack(
                children: stackChildren,
              )),
        ),
      ),
    );
  }
}
