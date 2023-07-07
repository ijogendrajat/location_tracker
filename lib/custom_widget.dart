import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void uzg19SnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 3),
    ),
  );
}

class CustomPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDataFromSharedPreferences(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return AlertDialog(
            backgroundColor: Colors.yellow,
            title: const Text('Location History'),
            content:
                SingleChildScrollView(child: Text(snapshot.data.toString())),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Clear Data'),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove("dataKey");
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to retrieve data from SharedPreferences.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text('Loading'),
            content: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<String> _getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('dataKey') ?? 'No data found';
  }
}

void showCustomPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomPopup();
    },
  );
}
