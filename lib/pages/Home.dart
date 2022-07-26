import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obj_detection/enums.dart';
import 'package:obj_detection/utils/constants.dart';
import 'package:obj_detection/utils/functions.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  final FlutterTts tts = FlutterTts();
  List<CameraDescription> cameras;
  List _recognitions;
  String _model = yolo;
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


  @override
  void initState() {
    super.initState();
    apiServices = ApiServices();
    startDateTime = getCurrentDateStr();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    loadModel(_model);
    initCamera();

    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Shake!')));

        if(pageName == PageName.home) {
          speak("Please point your camera at the target code");
        } else if (pageName == PageName.result) {
          speak("Swipe left to repeat, and swipe right to detect");
        }
      },
      minimumShakeCount: 3,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.inactive){
      recordDuration();
    } else if (state == AppLifecycleState.resumed) {
      setState((){
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
    switch (_model) {
      case yolo:
        await startObjectDetectionUsingYolo();
        break;
      case ssd:
        await startObjectDetectionUsingSSD();
        break;
    }
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

  startObjectDetectionUsingSSD() async {
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
          threshold: 0.4,
          imageMean: 127.5,
          imageStd: 127.5,
          numResultsPerClass: 1,
          // defaults to 0.1
        );
        isBusy = false;
      }
      print(_recognitions.length);
      setState(() {
        img;
      });
    }
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

  Future recordDuration() async{
    final preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("userId");

    await apiServices.duration(startDateTime, getCurrentDateStr(), "Result",  userId.toString(), onSuccess: (data){}, onError: (message){
      showSnackBar(context, "Failed to record duration", Colors.redAccent);
    });
  }

  void showBackdrop(String detectedClass) {
    try {
      setState(() {
        visible = true;
        pageName = PageName.result;
        controller.pausePreview();
        startDateTime = getCurrentDateStr();
        speak(detectedClass.toString());
      });
    } catch (e) {
      print(e);
    }

    countCapture(detectedClass.toString());
  }

  void hideBackdrop() {
    if(visible) {
      recordDuration();
    }

    setState(() {
      visible = false;
      topConfirm = false;
      pageName = PageName.home;
      controller.resumePreview();
    });
  }

  Future countCapture(String result) async{
    final preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("userId");
    await apiServices.capture(result, userId.toString(), onSuccess: (data){}, onError: (message){
      showSnackBar(context, "Failed to record capture", Colors.redAccent);
    });
  }

  Future countAction(String type) async{
    setState(() {
      isLoading = true;
    });
    final preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("userId");
    await apiServices.count(type, userId.toString(), onSuccess: (data){}, onError: (message){
      showSnackBar(context, "Failed to count action", Colors.redAccent);
    });
    setState(() {
      isLoading = false;
    });
  }

  Future speak(String obj) async {
    showVibration(context);
    await tts.setLanguage("en-US");
    await tts.speak("This is pattern " + obj);
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageHeight == null || _imageWidth == null) return [];
    double factorX = screen.width;
    double factorY = _imageHeight; // _imageWidth * screen.width;
    Color blue = Color.fromRGBO(37, 213, 253, 1.0);
    return _recognitions.map((re) {
      if (re["confidenceInClass"] * 100 > 50) {
        setState(() {
          detectedClass = re["detectedClass"];
          showBackdrop(re["detectedClass"]);
        });
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

    stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        height: size.height,
        child: Container(
          height: size.height,
          child: (!controller.value.isInitialized)
              ? new Container()
              : AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        )));

    if (img != null) {
      stackChildren.addAll(renderBoxes(size));
    }

    stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        height: size.height,
        child: Visibility(
            visible: visible,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                int sensitivity = 8;
                if (details.delta.dx > sensitivity) {
                  // Right Swipe
                  hideBackdrop();
                  countAction("swipe_right");
                  print("right *******************************");
                } else if (details.delta.dx < -sensitivity) {
                  //Left Swipe
                  speak(detectedClass);
                  countAction("swipe_left");
                  print("left *******************************");
                }
              },
              onVerticalDragUpdate: (details) {
                int sensitivity = 8;
                if (details.delta.dy > sensitivity) {
                  // Bottom swipe
                  if(bottomConfirm) {
                    speak("please wait, we will provide material recommendations").then((val) {
                      setState(() {
                        bottomConfirm = false;
                      });
                    });
                  } else {
                    speak("did you answer wrong? swipe down again to confirm").then((val) {
                      setState(() {
                        bottomConfirm = true;
                      });
                    });
                  }

                  countAction("swipe_bottom");
                } else if(details.delta.dy < -sensitivity){
                  // Top swipe
                  if (topConfirm) {
                    hideBackdrop();
                  } else {
                    speak("are you sure you answered correctly? if yes, please swipe up again").then((val) {
                      setState(() {
                        topConfirm = true;
                      });
                    });
                  }


                  countAction("swipe_top");
                }
              },
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            detectedClass,
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.white.withOpacity(0.3),
                          size: 35,
                        ),
                        Padding(padding: EdgeInsets.only(right: 15)),
                        Text(
                          "Swipe up to answer correctly",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white.withOpacity(0.3)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_downward,
                          color: Colors.white.withOpacity(0.3),
                          size: 35,
                        ),
                        Padding(padding: EdgeInsets.only(right: 15)),
                        Text(
                          "Swipe down to answer wrong",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white.withOpacity(0.3)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.white.withOpacity(0.3),
                          size: 35,
                        ),
                        Padding(padding: EdgeInsets.only(right: 15)),
                        Text(
                          "Swipe left to repeat speech",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white.withOpacity(0.3)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white.withOpacity(0.3),
                          size: 35,
                        ),
                        Padding(padding: EdgeInsets.only(right: 15)),
                        Text(
                          "Swipe right to scan",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white.withOpacity(0.3)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ))));

    stackChildren.add(Positioned(
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
        ) : Container()));

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
            color: Colors.black,
            child: Stack(
              children: stackChildren,
            )),
      ),
    );
  }
}
