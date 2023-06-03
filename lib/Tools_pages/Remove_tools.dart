import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../scaffold_adds/drawer.dart';

class Remove_tools extends StatefulWidget {
  const Remove_tools({super.key});

  @override
  State<Remove_tools> createState() => _Remove_toolsState();
}

class _Remove_toolsState extends State<Remove_tools> {
  var ref = FirebaseFirestore.instance.collection('users');
  DatabaseReference dataref = FirebaseDatabase.instance.ref();
  // bool val = false;
  List Pompes = [], Vannes = [];
  List<bool> checkedlistPompes = [], checkedlistVannes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remove'),
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
        stream: ref.doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
        // initialData: [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (Pompes.isEmpty && Vannes.isEmpty) {
            checkedlistPompes =
                List<bool>.generate(data['Pompes'].length, (index) => false);
            checkedlistVannes =
                List<bool>.generate(data['Vannes'].length, (index) => false);
          }
          Pompes = data['Pompes'] ?? [];
          Vannes = data['Vannes'] ?? [];

          // ignore: unnecessary_null_comparison
          if (data != null) {
            try {
              dataref.child(FirebaseAuth.instance.currentUser!.uid).update({
                'Pompes': Pompes,
                'Vannes': Vannes,
              });
            } catch (e) {
              print(' realtime Error : $e');
            }
          }
          return Container(
            width: double.maxFinite,
            height: double.maxFinite,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pompes',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 200,
                  child: ListView.builder(
                    itemCount: data['Pompes'].length,
                    // ignore: body_might_complete_normally_nullable
                    itemBuilder: (BuildContext context, int index) {
                      try {
                        return CheckboxListTile(
                            title: Text(
                                '${data['Pompes'][index]['Type']} ${index + 1}'),
                            value: checkedlistPompes[index],
                            onChanged: (value) {
                              setState(() {
                                print(checkedlistPompes[index]);
                                checkedlistPompes[index] = value!;
                                print(checkedlistPompes[index]);
                              });
                            });
                      } catch (e) {
                        print('Error remove : $e');
                      }
                    },
                  ),
                ),
                const Text(
                  'Vannes',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 250,
                  child: ListView.builder(
                    itemCount: data['Vannes'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                          title: Text(
                              '${data['Vannes'][index]['Type']} ${index + 1}'),
                          value: checkedlistVannes[index],
                          onChanged: (value) {
                            setState(() {
                              checkedlistVannes[index] = value!;
                            });
                          });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            for (var i = 0; i < checkedlistPompes.length; i++) {
              if (checkedlistPompes[i]) {
                Pompes.removeAt(i);
                checkedlistPompes.removeAt(i);
              }
            }
            for (var i = 0; i < checkedlistVannes.length; i++) {
              if (checkedlistVannes[i]) {
                Vannes.removeAt(i);
                checkedlistVannes.removeAt(i);
              }
            }
            ref.doc(FirebaseAuth.instance.currentUser!.uid).update({
              'Pompes': Pompes,
              'Vannes': Vannes,
            });
            // print();

            dataref.child(FirebaseAuth.instance.currentUser!.uid).update({
              'Pompes': Pompes,
              'Vannes': Vannes,
            });
          });
        },
        child: const Icon(Icons.delete),
      ),
    );
  }
}
