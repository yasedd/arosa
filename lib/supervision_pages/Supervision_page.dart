import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../scaffold_adds/drawer.dart';

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

    List Humidity_caps = [];
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
          Humidity_caps = data['Humidity_caps'] ?? [];
          dataref
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({'Humidity_caps': Humidity_caps});
          dataref
              .child('${FirebaseAuth.instance.currentUser!.uid}/Humidity_caps')
              .onValue
              .listen((event) {
            try {
              Humidity_caps = event.snapshot.value as List<dynamic>;
              ref.update({'Humidity_caps': Humidity_caps});
              print(Humidity_caps);
            } on Exception catch (e) {
              print(e);
            }
          });
          return ListView.builder(
            itemCount: Humidity_caps.length,
            itemBuilder: (BuildContext context, int index) {
              return Text('${Humidity_caps[index]}');
            },
          );
        },
      ),
    );
  }
}
