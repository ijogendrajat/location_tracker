import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://ijogendrajat.github.io/location_tracker/');

class ErrorScreen extends StatefulWidget {
  final String abc;

  const ErrorScreen({super.key, required this.abc});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Error",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text(
                "Something is not working 🫤 , don't worry we are here to help you",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: Text(
                  widget.abc,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.red),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    openAppSettings();
                  },
                  child: Text("Open Settings ⚙ "),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: _launchUrl,
        icon: const Icon(
          Icons.heart_broken,
          color: Colors.red,
          size: 50,
        ),
      ),
    );
  }
}
