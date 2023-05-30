import 'package:flutter/material.dart';

import '../scaffold_adds/drawer.dart';

class Remove_tools extends StatefulWidget {
  const Remove_tools({super.key});

  @override
  State<Remove_tools> createState() => _Remove_toolsState();
}

class _Remove_toolsState extends State<Remove_tools> {
  @override
  Widget build(BuildContext context) {
    var val;
    return Scaffold(
      appBar: AppBar(),
      drawer: drawer(),
      body: CheckboxListTile(value: val, onChanged: (value) {}),
    );
  }
}
