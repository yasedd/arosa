import 'package:arosa/scaffold_adds/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../scaffold_adds/alert.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  var userid = FirebaseAuth.instance.currentUser?.uid;
  var ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                showloading(context);
                await FirebaseAuth.instance.signOut();

                Navigator.of(context).pushReplacementNamed('Login');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      drawer: const drawer(),
      body: FutureBuilder(
        future: ref.get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          //Data is output to the user
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return ListView(children: [
              const SizedBox(
                height: 10,
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
                          color: Colors.grey,
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
                        '${data["Pompes"] == null ? 0 : data["Pompes"].length}',
                        // 'pss',
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
                          color: Colors.grey,
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
                        '${data['Vannes'] == null ? 0 : data['Vannes'].length}',
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
            ]);
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}
