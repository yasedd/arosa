import 'package:flutter/material.dart';

showloading(context) async {
  showDialog(
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 170),
          child: const AlertDialog(
            title: Text('Loading'),
            content: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      });
}
