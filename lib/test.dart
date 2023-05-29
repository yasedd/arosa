import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirestoreToRealtimeDatabase extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<void> sendFirestoreDataToRealtimeDatabase() async {
    // Retrieve data from Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('data')
        .get(); // Replace 'data' with your Firestore collection

    // Get the document data
    Map<String, dynamic>? data =
        snapshot.docs.isNotEmpty ? snapshot.docs.first.data() : null;

    if (data != null) {
      // Extract the arrays from Firestore data
      List<dynamic> array1 = data['array1'] ?? [];
      List<dynamic> array2 = data['array2'] ?? [];

      // Convert the arrays to a map for Realtime Database
      Map<String, dynamic> databaseData = {
        'array1': array1,
        'array2': array2,
      };

      // Send the data to the Realtime Database
      _databaseReference.child('data').set(
          databaseData); // Replace 'data' with your desired Realtime Database path
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore to Realtime Database'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Send Data'),
          onPressed: sendFirestoreDataToRealtimeDatabase,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FirestoreToRealtimeDatabase(),
  ));
}
