import 'package:flutter/material.dart';

void uzg19SnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: 2),
    ),
  );
}
