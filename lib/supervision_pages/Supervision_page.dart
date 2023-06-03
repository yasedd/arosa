import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../scaffold_adds/drawer.dart';
// import 'package:scaled_list/scaled_list.dart';

class Supervision_page extends StatefulWidget {
  const Supervision_page({super.key});

  @override
  State<Supervision_page> createState() => _Supervision_pageState();
}

class _Supervision_pageState extends State<Supervision_page> {
  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    var dataref = FirebaseDatabase.instance.ref();

    List Plants = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervision'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back))
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
          Plants = data['Plants'] ?? [];
          dataref
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({'Plants': Plants});
          dataref
              .child('${FirebaseAuth.instance.currentUser!.uid}/Plants')
              .onValue
              .listen((event) {
            try {
              Plants = event.snapshot.value as List<dynamic>;
              ref.update({'Plants': Plants});
              print(Plants);
            } on Exception catch (e) {
              print(e);
            }
          });
          int distwater = 0;
          for (var i = 0; i < data['Pompes'].length; i++) {
            distwater += data['Pompes'][i]['distributedwater'] as int;
          }
          return SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                        )
                      ]),
                  child: ListTile(
                    title: const Text('Distributedwater'),
                    leading: const Icon(Icons.water),
                    trailing: Text('$distwater'),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 500,
                  child: ListView.builder(
                    itemCount: data['Plants'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 150,
                        height: 250,
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
                          children: [
                            const Text(
                              'Humidity',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            CircularPercentIndicator(
                              radius: 70.0,
                              lineWidth: 10.0,
                              percent: ((data['Plants'][index]['Humidity']) /
                                  (1023)),
                              center: Text(
                                '${data['Plants'][index]['Humidity']}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              progressColor: ((data['Plants'][index]
                                              ['Humidity']) /
                                          (1023)) ==
                                      0.9
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            Text(
                              data['Plants'][index]['name'],
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
