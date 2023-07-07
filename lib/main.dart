import 'package:flutter/material.dart';
import 'package:location_tracker/error_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.location.request();
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return ErrorScreen(
      abc: errorDetails.toString(),
    );
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UZG19-Location',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
