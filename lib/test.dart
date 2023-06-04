import 'package:flutter/material.dart';
import 'dart:async';

import 'package:intl/intl.dart';

// import 'package:intl/intl.dart';

class DurationScreen extends StatefulWidget {
  @override
  _DurationScreenState createState() => _DurationScreenState();
}

class _DurationScreenState extends State<DurationScreen> {
  bool switchValue = false;
  String presetTime = '01:24 AM';
  String anotherTime = '01:25 AM';
  Timer? timer;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      var currentTime = DateTime.now();
      var formattedTime = DateFormat('hh:mm a').format(currentTime);
      if (formattedTime == presetTime) {
        setState(() {
          switchValue = true;
        });
      } else if (formattedTime == anotherTime) {
        setState(() {
          switchValue = false;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Switch Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Preset Time: $presetTime',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Another Time: $anotherTime',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Switch(
              value: switchValue,
              onChanged: (value) {
                setState(() {
                  switchValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
