import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

import 'custom_fn.dart';
import 'custom_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String latlon = "nothing";
  List<List<dynamic>> data = [];
  late Position position;
  // [01] permission ---------------------------------------------------
  late LocationPermission permission;
  void requestPermission() async {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      uzg19SnackBar(context, "Permission Needed 🚨");
      setState(() {
        requestPermission();
      });
    } else if (permission == LocationPermission.deniedForever) {
      uzg19SnackBar(context, "⚠️ Bye Bye / System Settings");
      setState(() {
        requestPermission();
      });
    } else {
      uzg19SnackBar(context, "Welcome 🤗");
    }
  }

  // [01] permission ---------------------------------------------------
  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
      //timeLimit: Duration(seconds: 1),
    );
    // var _locationText =
    //     'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
    // print(_locationText);
    // uzg19SnackBar(context, _locationText);
    List<double> newLocation = [position.latitude, position.longitude];
    print(newLocation);
    data.add(newLocation);
    setState(() {});
  }

  bool startRecording = false;
  dataWriter() {
    while (startRecording) {}
  }

  @override
  void initState() {
    requestPermission();
    determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("geolocation"),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  //requestPermission();
                  getCurrentLocation();
                },
                child: const Text("start"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    // determinePosition();
                    if (await Permission.location.isDenied) {
                      // The user opted to never again see the permission request dialog for this
                      // app. The only way to change the permission's status now is to let the
                      // user manually enable it in the system settings.
                      openAppSettings();
                    }
                    if (await Permission.location.isGranted) {
                      // Either the permission was already granted before or the user just granted it.
                    }
                    // You can request multiple permissions at once.
                    Map<Permission, PermissionStatus> statuses = await [
                      Permission.location,
                      // Permission.storage,
                    ].request();
                    print(statuses[Permission.location]);
                  },
                  child: Text("end")),
              Wrap(children: [Text(data.toString())]),
            ],
          ),
        ),
      ),
    );
  }
}
