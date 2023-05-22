// import 'package:arosa/main.dart';

import 'package:arosa/scaffold_adds/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  List pompes = [
    {
      'Type': 'Pompe',
      'state': false,
      'Time to Start': '12:30',
      'Time to End': '14:30',
      'distributed water': 0,
    }
  ];
  List valves = [
    {
      'Num of Valve': 1,
      'state': false,
      'O or F': '',
      'Time to Start': '12:30',
      'Time to End': '14:30',
    },
    {
      'Num of Valve': 2,
      'state': false,
      'Time to Start': '12:30',
      'Time to End': '13:30',
    },
    {
      'Num of Valve': 3,
      'state': false,
      'Time to Start': '13:30',
      'Time to End': '14:30',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('Login');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      drawer: const drawer(),
      body: ListView(children: [
        // const SizedBox(
        //   height: 40,
        // ),
        InkWell(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                  )
                ]),
            width: double.maxFinite,
            height: 270,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Pompes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Image.asset(
                  'images/POMPE-icon.jpg',
                  width: 150,
                  height: 150,
                ),
                Text(
                  '${pompes.length}',
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed('State_tools');
          },
        ),
        InkWell(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                  )
                ]),
            width: double.maxFinite,
            height: 270,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Vannes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Image.asset(
                  'images/valve-removebg-preview.png',
                  width: 150,
                  height: 150,
                ),
                Text(
                  '${valves.length}',
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed('State_tools');
          },
        ),
      ]),
    );
  }
}
