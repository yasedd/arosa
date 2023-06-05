import 'package:arosa/scaffold_adds/drawer.dart';
// import 'package:arosa/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../scaffold_adds/alert.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  // var userid = FirebaseAuth.instance.currentUser?.uid;
  var ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  DatabaseReference dataref = FirebaseDatabase.instance.ref();

  late String mode;
  List Pompes = [];
  List Vannes = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          // IconButton(
          //     onPressed: () {
          //       Navigator.of(context).push(
          //           MaterialPageRoute(builder: (context) => DurationScreen()));
          //     },
          //     icon: Icon(Icons.abc)),
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
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          Pompes = data['Pompes'] ?? [];
          Vannes = data['Vannes'] ?? [];
          // mode = data['mode'];
          dataref.child(FirebaseAuth.instance.currentUser!.uid).update({
            'Pompes': Pompes,
            'Vannes': Vannes,
          });
          return ListView(children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.maxFinite,
              height: 150,
              margin: const EdgeInsets.all(10),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     ElevatedButton.icon(
                  //       onPressed: () {
                  //         setState(() {
                  //           if (mode == 'Manuel') {
                  //             mode = 'Automatique';
                  //           } else {
                  //             mode = 'Manuel';
                  //           }
                  //           ref.update({'mode': mode});
                  //           dataref
                  //               .child(FirebaseAuth.instance.currentUser!.uid)
                  //               .update({'mode': mode});
                  //         });
                  //       },
                  //       label: const Text('Mode'),
                  //       icon: const Icon(Icons.check_circle_outline_outlined),
                  //       style: ElevatedButton.styleFrom(
                  //           fixedSize: const Size.fromRadius(48),
                  //           backgroundColor: Colors.blueGrey),
                  //     ),
                  //     Container(
                  //       padding: const EdgeInsets.all(5),
                  //       width: 200,
                  //       height: 95,
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(5),
                  //           boxShadow: const [
                  //             BoxShadow(
                  //               color: Colors.grey,
                  //               blurRadius: 2,
                  //             )
                  //           ]),
                  //       child: Center(
                  //           child: Text(
                  //         mode,
                  //         style: const TextStyle(
                  //             fontSize: 20, fontWeight: FontWeight.bold),
                  //       )),
                  //     )
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 145,
                          height: 95,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2,
                                )
                              ]),
                          child: const Center(
                            child: Text(
                              'Controle',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('State_tools');
                        },
                      ),
                      InkWell(
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            width: 148,
                            height: 95,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                  )
                                ]),
                            child: const Center(
                              child: Text(
                                'Supervision',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        onTap: () {
                          Navigator.of(context).pushNamed('Supervision');
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
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
                  width: 150,
                  height: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Pompes',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Image.asset(
                        'images/POMPE-icon.jpg',
                        width: 70,
                        height: 70,
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
                Container(
                  margin: const EdgeInsets.all(10),
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
                  width: 150,
                  height: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Vannes',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Image.asset(
                        'images/valve-removebg-preview.png',
                        width: 70,
                        height: 70,
                      ),
                      Text(
                        '${data['Vannes'] == null ? 0 : data['Vannes'].length}',
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.all(10),
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
                    width: 150,
                    height: 120,
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Icon(Icons.add), Text('Ajouter')]),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('Add_tools');
                  },
                ),
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.all(10),
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
                    width: 150,
                    height: 120,
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Icon(Icons.delete), Text('Supprimer')]),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('Remove_tools');
                  },
                )
              ],
            )
          ]);
        },
      ),
    );
  }
}
