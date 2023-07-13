import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:location_tracker/error_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<dynamic>> data = [];
  late Position position;
  // [01] permission ---------------------------------------------------
  late LocationPermission permission;
  void requestPermission() async {
    permission = await Geolocator.requestPermission();
    String message = "";
    if (permission == LocationPermission.denied) {
      message = "Permission Needed 🚨";
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ErrorScreen(
                  abc: message,
                )),
      );
    } else if (permission == LocationPermission.deniedForever) {
      message =
          "⚠️ need your location permission to run this app open setting and give location permission to this app in system settings";
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ErrorScreen(
                  abc: message,
                )),
      );
    } else {
      message = "Welcome 🤗";
    }
    // ignore: use_build_context_synchronously
    //uzg19SnackBar(context, message);
  }

// [02] Current location ---------------------------------------------------
  // void getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.best,
  //     forceAndroidLocationManager: true,
  //     // timeLimit: Duration(seconds: 1),
  //   );
  //   List<double> newLocation = [position.latitude, position.longitude];
  //   data.add(newLocation);
  //   setState(() {});
  // }

  // [03] Save Data ---------------------------------------------------
  late StreamSubscription<Position> positionStreamSubscription;
  startBtn() {
    positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        List<dynamic> newLocation = [
          position.latitude,
          position.longitude,
          DateTime.now().toString()
        ];
        data.add(newLocation);
      });
    });
  }

  stopBtn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(data);
    await prefs.setString("dataKey", encodedData);
    positionStreamSubscription.cancel();
  }

  // [04] Sharedpref

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          "UZG19-Location",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: startBtn,
                    child: const Text(
                      "start",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: stopBtn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        "end",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                  child: Wrap(children: [Text(data.toString())])),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
          onPressed: () {
            showCustomPopup(context);
          },
          icon: const Icon(
            Icons.history,
            color: Colors.green,
            size: 50,
          )),
    );
  }
}
